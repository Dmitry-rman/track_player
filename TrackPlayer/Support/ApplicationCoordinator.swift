//
//  ApplicationCoordinator.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import SwiftUI
import Combine

/// App UI Coordinator
final class ApplicationCoordinator: NavigationCoordinator {
    
    private let diContainer: DiContainer
    private weak var songListViewInput: TrackListViewModuleInput?
    private var stateCancellable: AnyCancellable?
    
    init(diContainer: DiContainer, container: NavigationContainer) {
        
        self.diContainer = diContainer
        super.init(container: container)
    }
    
    @discardableResult
    override func start(animated: Bool) -> UIViewController {
        
        let module =  TrackListViewModule(output: self, container: diContainer)
        container?.pushViewController(module.view, animated: animated)
        songListViewInput = module.input
        
        loadState()
        
        return module.view
    }
    
    /// Loading state
    func loadState(){
        
        stateCancellable = self.diContainer.serviceBuilder.getFavoritesService()
            .getFavoritesCount()
            .sink { result in
                switch result{
                case .failure(let error):
                    debugPrint(error)
                default:
                    break
                }
            } receiveValue: { [weak self] value in
                self?.diContainer.appState.bulkUpdate({ state in
                    state.userData.favoritsCount = value
                })
            }
    }
    
    private func showTrackView(track: TrackSong){
        
        let player: TrackPlayer
        if diContainer.player.playingTrack?.id == track.id{
            player = diContainer.player
        }else{
            player = diContainer.serviceBuilder.createPlayer()
        }
     
        let module = TrackViewModule(song: track,
                                    player: player,
                                    output: self,
                                    container: self.diContainer)
        container?.present(module.view, animated: true)
    }
    
}

extension ApplicationCoordinator: BaseTrackListViewOutput{
    

}

extension ApplicationCoordinator: TrackListViewModuleOutput{
    
    
    func searchListDidSelectTrack(_ track: TrackSong) {
        showTrackView(track: track)
    }
    
    func showAbout(){
        
        let module = AboutViewModule(output: self, container: self.diContainer)
        container?.present(module.view, animated: true)
    }
    
    func showFavorites(){
        
        let module = FavoritesViewModule(output: self, container: self.diContainer)
        container?.pushViewController(module.view, animated: true)
    }
    
}

extension ApplicationCoordinator: SongViewModuleOutput{
    
    func songViewDidClosed() {
        container?.dismiss(animated: true)
    }
}

extension ApplicationCoordinator: AboutViewModuleOutput{
    
    func aboutDidClosed() {
        
        container?.dismiss(animated: true)
    }
}

extension ApplicationCoordinator: FavoritesViewModuleOutput{
    
    func didSelectFavoritTrack(_ track: TrackSong) {
        showTrackView(track: track)
    }
}
