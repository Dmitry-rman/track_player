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
        
        self.viewModel.container.appState
            .map{
                $0.userData.favorites.count
            }
            .sink(receiveValue: {[weak self] count in
                self?.rightButton?.title = count == 0 ? String.pallete(.favorites) : String.pallete(.favorites) + "(\(count))"
            })
            .store(in: &cancellableSet)
    }
    
    @objc
    private func rightButtonTap(_ sender: Any) {
        
        debugPrint("rightButtonTap")
    }
    
    init(viewModel: ViewModel, rootView: TrackListView<ViewModel>) {
        
        self.viewModel = viewModel
        super.init(rootView: rootView)
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrackListViewController: TrackListViewModuleInput{
    
    var player: AVSoundPlayer? {
        viewModel.player
    }
    
    func playTrack(track: TrackSong, withPlayer player: AVSoundPlayer) {
        viewModel.trackDidPlayed(track: track, withPlayer: player)
    }
    
}
