//
//  SongsListViewController.swift
//  PiratePlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation
import SwiftUI

final class SongsListViewController<ViewModel: SongsListViewModelProtocol>: AppHostingController<SongsListView<ViewModel>> {
    
    var viewModel: ViewModel?
    
    override func setupController() {
        
        super.setupController()
        navigationItem.title = String.pallete(.songsListScreenTitle)
    }
}

extension SongsListViewController: SongsListViewModuleInput{
    
    func playTrack(track: TrackSong, withPlayer player: AVSoundPlayer) {
        viewModel?.trackDidPlayed(track: track, withPlayer: player)
    }
    
}
