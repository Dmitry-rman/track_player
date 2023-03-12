//
//  SongsListViewModule.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import UIKit

///Input module protocol
protocol TrackListViewModuleInput: AnyObject{
    
    func playTrack(track: TrackSong, withPlayer player: AVSoundPlayer)
    
    var player: AVSoundPlayer? {get}
}

///Output module protocol
protocol TrackListViewModuleOutput: AnyObject{
    
    func didSelectSong(song: TrackSong)
}

struct TrackListViewModule: ViewModuleProtocol{
    
    private var viewController: TrackListViewController<TrackListViewModel>
    
    /// Visual representation of module
    var view: UIViewController {
        viewController
    }
    
    var input: TrackListViewModuleInput{
        viewController
    }
    
    init(output: TrackListViewModuleOutput, container: DiContainer) {
        
        let viewModel = Self.createViewModel(output: output, container: container)
        
        viewController = TrackListViewController(rootView: TrackListView(viewModel: viewModel))
        viewController.viewModel = viewModel
    }
    
    private static func createViewModel(output: TrackListViewModuleOutput, container: DiContainer) ->  TrackListViewModel{
        return TrackListViewModel(output: output, container: container)
    }
}
