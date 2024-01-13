//
//  FavoritesViewModel.swift
//  TrackPlayer
//
//  Created by Dmitry on 13.03.2023.
//

import Combine
import Foundation

protocol FavoritesViewModelProtocol: IBaseTrackListViewModel{
    
    func removeTrack(at offsets: IndexSet)
    func reloadFavorites()
}

final class FavoritesViewModel: BaseTrackListViewModel, FavoritesViewModelProtocol{

    private weak var output: FavoritesViewModuleOutput?
    
    private var loadFavoritesPublisher: AnyPublisher<[TrackSong], Error>{
        self.container.serviceBuilder.getFavoritesService().getFavorites()
    }
    
    convenience init(output: FavoritesViewModuleOutput, container: DiContainer){
        
        self.init(state: .empty, container: container)
        self.output = output
        
        container.appState
            .flatMap{[weak self] result -> AnyPublisher<[TrackSong], Never> in
                
                guard let self = self else {
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                }
                
                return self.container.serviceBuilder.getFavoritesService()
                    .getFavorites()
                    .catch({ error -> AnyPublisher<[TrackSong], Never> in
                        debugPrint(error)
                        return Empty(completeImmediately: true)
                            .eraseToAnyPublisher()
                    })
                    .eraseToAnyPublisher()
            }
            .sink {[weak self] tracks in
                self?.stateMachine.setState(.content(tracks, .default))
            }
            .store(in: &cancellableSet)
    }
    
    override func startScenario() {
        
        guard !isScenarioStarted else { return }
        isScenarioStarted = true
        
        super.startScenario()
        
        self.analytics.logEvent(AppEventAnalytics.favorites_screen_visited)
        
        //self.stateMachine.setState(.loading)
    }
    
    override func selectTrack(_ track: TrackSong) {
        
        super.selectTrack(track)
        output?.didSelectFavoritTrack(track)
    }
    
    func reloadFavorites() {
        
        loadFavoritesPublisher
            .sink { [weak self] error in
                debugPrint(error)
                if let error = error as? Error{
                    self?.stateMachine.setState(.content((nil), .error(error)))
                }
            } receiveValue: {  [weak self] songs in
                self?.stateMachine.setState(.content((songs), .default))
            }
            .store(in: &cancellableSet)
    }
    
    func removeTrack(at offsets: IndexSet) {
        
        debugPrint("remove \(offsets)")
        
        switch stateMachine.state{
        case .content(let tracks, _):
            
            var result = tracks ?? []
            let tracksToDelete = offsets.map { result[$0]}
            
            result.remove(atOffsets: offsets)
            stateMachine.setState(.content(result, .default))
            
            container.serviceBuilder.getFavoritesService()
                .removeTracksFromFavorites(tracksToDelete)
                .sinkStore(in: &cancellableSet)
            
        default:
            break
        }
    }
}
