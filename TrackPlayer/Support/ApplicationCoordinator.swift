//
//  ApplicationCoordinator.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import SwiftUI

/// App UI Coordinator
final class ApplicationCoordinator: NavigationCoordinator {
    
    private let diContainer: DiContainer
    private weak var mainPlayer: AVSoundPlayer?
    
    private weak var songListViewInput: SongsListViewModuleInput?

    init(diContainer: DiContainer, container: NavigationContainer) {
        
        self.diContainer = diContainer
        super.init(container: container)
    }
    
    @discardableResult
    override func start(animated: Bool) -> UIViewController {
        
        let module =  SongsListViewModule(output: self, container: diContainer)
        container?.pushViewController(module.view, animated: animated)
        songListViewInput = module.input
        
        return module.view
    }
}

extension ApplicationCoordinator: SongsListViewModuleOutput{
    
    func didSelectSong(song: TrackSong) {
        
        debugPrint("select song \(song)")
        let module = SongViewModule(song: song, output: self, container: self.diContainer)
        container?.isNavigationBarHidden = true
        container?.pushViewController(module.view, animated: true)
    }
    
}

extension ApplicationCoordinator: SongViewModuleOutput{
    
    func songViewDidClosed() {
        container?.isNavigationBarHidden = false
        container?.popViewController(animated: true)
    }
    
    func playerDidPlay(track: TrackSong, withPlayer player: AVSoundPlayer) {
        
        self.mainPlayer?.stop()
        self.mainPlayer = player
        self.songListViewInput?.playTrack(track: track, withPlayer: player)
    }
}
