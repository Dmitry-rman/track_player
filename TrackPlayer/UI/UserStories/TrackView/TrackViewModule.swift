//
//   SongViewModule.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import UIKit

protocol SongViewModuleOutput: AnyObject{
    
    func songViewDidClosed()
}

struct TrackViewModule: ViewModuleProtocol {
    
    private var viewController: TrackViewController<TrackViewModel>
    
    /// Визуальное представление модуля
    var view: UIViewController {
        viewController
    }
    
    init(song: TrackSong, player: TrackPlayer, output: SongViewModuleOutput, container: DiContainer) {
        
        let viewModel = Self.createViewModel(song: song, output: output, player: player, container: container)
        
        viewController = TrackViewController(rootView: TrackView(viewModel: viewModel))
        viewController.viewModel = viewModel
    }
    
    private static func createViewModel(song: TrackSong, output: SongViewModuleOutput, player: TrackPlayer, container: DiContainer) ->  TrackViewModel{
        return TrackViewModel(song: song, output: output, player: player, container: container)
    }
}
