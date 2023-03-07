//
//   SongViewModule.swift
//  PiratePlayer
//
//  Created by Dmitry on 04.03.2023.
//

import UIKit

protocol SongViewModuleOutput: AnyObject{
    
    func songViewDidClosed()
    func playerDidPlay(track: TrackSong, withPlayer player: AVSoundPlayer)
}

struct SongViewModule: ViewModuleProtocol {
    
    private var viewController: SongViewController<SongViewModel, AVSoundPlayer>
    
    /// Визуальное представление модуля
    var view: UIViewController {
        viewController
    }
    
    init(song: TrackSong, output: SongViewModuleOutput, container: DiContainer) {
        
        let viewModel = Self.createViewModel(song: song, output: output, container: container)
        
        let player = container.serviceBuilder.getAudioEngine().createPlayer()
        viewController = SongViewController(rootView: SongView(viewModel: viewModel, player: player))
        viewController.viewModel = viewModel
    }
    
    private static func createViewModel(song: TrackSong, output: SongViewModuleOutput, container: DiContainer) ->  SongViewModel{
        return SongViewModel(song: song, output: output, container: container)
    }
}
