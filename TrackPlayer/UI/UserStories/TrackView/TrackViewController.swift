//
//  SongViewController.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation

final class TrackViewController<ViewModel: TrackViewModelProtocol>: AppHostingController<TrackView<ViewModel>> {
    var viewModel: ViewModel?
    
    override func setupController() {
        super.setupController()
        
        //For example only in this App.
        //To implement custom close action by coordinator later
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}
