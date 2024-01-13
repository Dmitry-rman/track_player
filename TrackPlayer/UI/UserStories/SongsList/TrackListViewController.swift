//
//  SongsListViewController.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation
import SwiftUI
import Combine

final class TrackListViewController<ViewModel: TrackListViewModelProtocol>: AppHostingController<TrackListView<ViewModel>> {
    let viewModel: ViewModel
    
    private var cancellableSet = Set<AnyCancellable>()
    private weak var rightButton: UIBarButtonItem?
    
    override func setupController() {
        super.setupController()
        
        navigationItem.title = String.pallete(.songsListScreenTitle)
        
        let rightButton = UIBarButtonItem(title: "",
                                         style: .plain,
                                         target: self,
                                          action: #selector(rightButtonTap(_:)))
        navigationItem.setRightBarButton(rightButton, animated: false)
        self.rightButton = rightButton
        
        let leftButton = UIBarButtonItem(title: String.pallete(.aboutButtonTitle),
                                         style: .plain,
                                         target: self,
                                          action: #selector(leftButtonTap(_:)))
        navigationItem.setLeftBarButton(leftButton, animated: false)
        
        self.viewModel.container.appState
            .map{ $0.userData.favoritsCount}
            .sink(receiveValue: {[weak self] count in
                self?.rightButton?.title = count == 0 ? String.pallete(.favorites) : String.pallete(.favorites) + "(\(count))"
            })
            .store(in: &cancellableSet)
    }
    
    @objc
    private func leftButtonTap(_ sender: Any) {
        viewModel.output?.showAbout()
    }
    
    @objc
    private func rightButtonTap(_ sender: Any) {
        viewModel.output?.showFavorites()
    }
    
    init(viewModel: ViewModel, rootView: TrackListView<ViewModel>) {
        self.viewModel = viewModel
        super.init(rootView: rootView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrackListViewController: TrackListViewModuleInput {}
