//
//   SongViewModule.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import UIKit

protocol SongViewModuleOutput: AnyObject{
    
    func songViewDidClosed()
    func playerDidPlay(track: TrackSong, withPlayer player: AVSoundPlayer)
}

struct TrackViewModule: ViewModuleProtocol {
    
    private var viewController: TrackViewController<TrackViewModel, AVSoundPlayer>
    
    /// Визуальное представление модуля
    var view: UIViewController {
        viewController
    }
    
    init(song: TrackSong, player: AVSoundPlayer, output: SongViewModuleOutput, container: DiContainer) {
        
        let viewModel = Self.createViewModel(song: song, output: output, container: container)
        
        viewController = TrackViewController(rootView: TrackView(viewModel: viewModel, player: player))
        viewController.viewModel = viewModel
    }
    
    private static func createViewModel(song: TrackSong, output: SongViewModuleOutput, container: DiContainer) ->  TrackViewModel{
        return TrackViewModel(song: song, output: output, container: container)
    }
}
