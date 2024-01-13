//
//  SongsListViewModel.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation
import Combine

final class TrackListViewModel: BaseTrackListViewModel, TrackListViewModelProtocol {
    @Published var searchQuery: String = ""
    @Published var searching: Bool = false
    
    var onShowPlayer: ((_ isShowed: Bool)->())?
    
    //Limit for API's track results
    private let searchResultLimit: Int
    private(set) weak var output: TrackListViewModuleOutput?
    
    convenience init(output: TrackListViewModuleOutput,
                     diContainer: DiContainer,
                     searchResultLimit: Int = 25) {
        
        self.init(state: .empty,
                  diContainer: diContainer,
                  searchResultLimit: searchResultLimit)
        self.output = output
    }
    
    init(
        state: ViewState<[TrackSong]?>,
        diContainer: DiContainer,
        searchResultLimit: Int) {
            self.searchResultLimit = searchResultLimit
            super.init(state: state, container: diContainer)
            
            switch state {
            case .content(let list, _):
                if let list = list{
                    self.tracks = list
                }
            default:
                break
            }
            
            stateMachine.$state.sink { [weak self] state in
                guard let self = self else {return}
                
                switch state{
                case .content( _, _):
                    self.onShowPlayer?(container.player.playingTrack != nil)
                default:
                    break
                }
                self.objectWillChange.send()
            }
            .store(in: &cancellableSet)
            
            $searchQuery
                .filter{ $0.count >= 3}//3 symbols or more to search
                .throttle(for: .seconds(0.5), scheduler: RunLoop.main, latest: true)
                .removeDuplicates()
                .eraseToAnyPublisher()
                .flatMap { [weak self] query -> AnyPublisher<[TrackSong], Never> in
                    
                    guard let self = self else {
                        return  Empty(completeImmediately: true).eraseToAnyPublisher()
                    }
                    
                    self.searching = true
                    return self.songService.getSongs(byQuery: query, limit: self.searchResultLimit)
                        .catch({[weak self] error -> AnyPublisher<[TrackSong], Never> in
                            debugPrint(error)
                            self?.searching = false
                            self?.stateMachine.setState(.content(nil, .error(error)))
                            return Empty(completeImmediately: true).eraseToAnyPublisher()
                        })
                        .eraseToAnyPublisher()
                }
                .sink { [weak self] error in    
                    guard let self = self else {return}
                    
                    if let error = error as? Error{
                        self.stateMachine.setState(.content((self.tracks), .error(error)))
                    }
                } receiveValue: { [weak self] songs in
                    self?.stateMachine.setState(.content(songs, .default))
                    self?.searching = false
                }
                .store(in: &cancellableSet)
            
            container.player.$isPlaying
                .sink { [weak self] playing in
                    self?.onShowPlayer?(true)
                }
                .store(in: &cancellableSet)
        }
    
    //MARK: - SongsListViewModelProtocol
    
    override func onFirstAppear() {
        super.onFirstAppear()
        
        self.analytics.logEvent(AppEventAnalytics.main_screen_visited)
        self.stateMachine.setState(.loading)
        loadRecent()
        // searchQuery = "Abba"
    }
    
    private func loadRecent() {
        self.songService
            .loadRecentSongs()
            .sink { [weak self] error in
                guard let self = self else {return}
                debugPrint(error)
                if let error = error as? Error{
                    self.stateMachine.setState(.content((self.tracks), .error(error)))
                }
            } receiveValue: {  [weak self] songs in
                guard let self = self else {return}
                self.stateMachine.setState(.content((songs.count > 0 ? songs : nil), .default))
            }
            .store(in: &cancellableSet)
    }
    
    override func selectTrack(_ track: TrackSong) {
        super.selectTrack(track)
        self.output?.searchListDidSelectTrack(track)
    }
    
    func clearSearch() {
        searchQuery = ""
    }
}
