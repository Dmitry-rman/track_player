//
//  SongsListViewModule.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import UIKit

///Input module protocol
protocol TrackListViewModuleInput: BaseTrackListViewOutput{
    
}

///Output module protocol
protocol TrackListViewModuleOutput: AnyObject{
    
    func searchListDidSelectTrack(_ track: TrackSong)
    func showAbout()
    func showFavorites()
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
        
        let viewModel = Self.createViewModel(output: output,
                                             container: container)
        viewController = TrackListViewController(viewModel: viewModel,
                                                 rootView: TrackListView(viewModel: viewModel))
    }
    
    private static func createViewModel(output: TrackListViewModuleOutput, container: DiContainer) ->  TrackListViewModel{
        return TrackListViewModel(output: output, container: container)
    }
}
