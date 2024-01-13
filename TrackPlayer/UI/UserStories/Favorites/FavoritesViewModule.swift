//
//  FavoritesViewModule.swift
//  TrackPlayer
//
//  Created by Dmitry on 13.03.2023.
//

import UIKit

protocol FavoritesViewModuleOutput: BaseTrackListViewOutput{
   func didSelectFavoritTrack(_ track: TrackSong)
}

struct FavoritesViewModule: ViewModuleProtocol{
    private var viewController: FavoritesViewController<FavoritesViewModel>
    
    /// Visual representation of module
    var view: UIViewController {
        viewController
    }
    
    init(output: FavoritesViewModuleOutput, container: DiContainer) {
        let viewModel = Self.createViewModel(output: output, container: container)
        viewController = FavoritesViewController(viewModel: viewModel,
                                                 rootView: FavoritesView(viewModel: viewModel))
    }
    
    private static func createViewModel(output: FavoritesViewModuleOutput, container: DiContainer) ->  FavoritesViewModel{
         FavoritesViewModel(output: output, container: container)
    }
}
