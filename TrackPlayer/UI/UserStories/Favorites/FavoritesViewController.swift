//
//  FavoritesViewController.swift
//  TrackPlayer
//
//  Created by Dmitry on 13.03.2023.
//

import Foundation

final class FavoritesViewController<ViewModel: FavoritesViewModel>: AppHostingController<FavoritesView<ViewModel>>{
    let viewModel: ViewModel
    
    init(viewModel: ViewModel, rootView: FavoritesView<ViewModel>) {
        self.viewModel = viewModel
        super.init(rootView: rootView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupController() {
        
        super.setupController()
        navigationItem.title = String.pallete(.favorites)
    }
}
