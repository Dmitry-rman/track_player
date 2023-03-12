//
//  SongsListViewController.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation
import SwiftUI

final class TrackListViewController<ViewModel: TrackListViewModelProtocol>: AppHostingController<TrackListView<ViewModel>> {
    
    var viewModel: ViewModel?
    
    override func setupController() {
        
        super.setupController()
        navigationItem.title = String.pallete(.songsListScreenTitle)
    }
}

extension TrackListViewController: TrackListViewModuleInput{
    
    var player: AVSoundPlayer? {
        viewModel?.player
    }
    
    func playTrack(track: TrackSong, withPlayer player: AVSoundPlayer) {
        viewModel?.trackDidPlayed(track: track, withPlayer: player)
    }
    
}
