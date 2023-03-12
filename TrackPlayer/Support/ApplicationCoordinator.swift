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
    private weak var songListViewInput: TrackListViewModuleInput?

    init(diContainer: DiContainer, container: NavigationContainer) {
        
        self.diContainer = diContainer
        super.init(container: container)
    }
    
    @discardableResult
    override func start(animated: Bool) -> UIViewController {
        
        let module =  TrackListViewModule(output: self, container: diContainer)
        container?.pushViewController(module.view, animated: animated)
        songListViewInput = module.input
        
        return module.view
    }
}

extension ApplicationCoordinator: TrackListViewModuleOutput{
    
    func didSelectSong(song: TrackSong) {
        
        debugPrint("select song \(song)")
        
        let player: AVSoundPlayer
        if let mainPlayer = self.songListViewInput?.player,
           mainPlayer.soundUrl == song.trackUrl {
            player = mainPlayer
        }else{
            player = diContainer.serviceBuilder.getAudioEngine().createPlayer()
        }
        
        let module = TrackViewModule(song: song,
                                    player: player,
                                    output: self,
                                    container: self.diContainer)
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
        
        if let mainPlayer = self.songListViewInput?.player,
           mainPlayer.soundUrl == track.trackUrl {
            
        }else{
            self.songListViewInput?.player?.stop()
        }
        self.songListViewInput?.playTrack(track: track, withPlayer: player)
    }
}
