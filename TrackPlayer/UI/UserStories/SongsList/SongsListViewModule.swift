//
//  SongsListViewModule.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import UIKit

///Input module protocol
protocol SongsListViewModuleInput: AnyObject{
    
    func playTrack(track: TrackSong, withPlayer player: AVSoundPlayer)
}

///Output module protocol
protocol SongsListViewModuleOutput: AnyObject{
    
    func didSelectSong(song: TrackSong)
}

struct SongsListViewModule: ViewModuleProtocol{
    
    private var viewController: SongsListViewController<SongsListViewModel>
    
    /// Визуальное представление модуля
    var view: UIViewController {
        viewController
    }
    
    var input: SongsListViewModuleInput{
        viewController
    }
    
    init(output: SongsListViewModuleOutput, container: DiContainer) {
        
        let viewModel = Self.createViewModel(output: output, container: container)
        
        viewController = SongsListViewController(rootView: SongsListView(viewModel: viewModel))
        viewController.viewModel = viewModel
    }
    
    private static func createViewModel(output: SongsListViewModuleOutput, container: DiContainer) ->  SongsListViewModel{
        return SongsListViewModel(output: output, container: container)
    }
}
