//
//  SongsListViewModule.swift
//  PiratePlayer
//
//  Created by Dmitry on 04.03.2023.
//

import UIKit

protocol SongsListViewModuleOutput: AnyObject{
    
    func didSelectSong(song: TrackSong)
}

struct SongsListViewModule: ViewModuleProtocol{
    
    private var viewController: SongsListViewController<SongsListViewModel>
    
    /// Визуальное представление модуля
    var view: UIViewController {
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
