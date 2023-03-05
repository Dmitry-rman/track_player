//
//  ApplicationCoordinator.swift
//  PiratePlayer
//
//  Created by Dmitry on 04.03.2023.
//

import SwiftUI

/// App UI Coordinator
final class ApplicationCoordinator: NavigationCoordinator {
    
    private let diContainer: DiContainer
    private let player: AVSoundPlayer = AVSoundPlayer()

    init(diContainer: DiContainer, container: NavigationContainer) {
        
        self.diContainer = diContainer
        super.init(container: container)
    }
    
    @discardableResult
    override func start(animated: Bool) -> UIViewController {
        
        let module =  SongsListViewModule(output: self, container: diContainer)
        container?.pushViewController(module.view, animated: animated)
        
        return module.view
    }
}

extension ApplicationCoordinator: SongsListViewModuleOutput{
    
    func didSelectSong(song: TrackSong) {
        
        player.stop()
        debugPrint("select song \(song)")
        let module = SongViewModule(song: song, player: player, output: self, container: self.diContainer)
        container?.pushViewController(module.view, animated: true)
    }
    
}

extension ApplicationCoordinator: SongViewModuleOutput{
    
    func songViewDidClosed() {
        
        container?.popViewController(animated: true)
    }
}
