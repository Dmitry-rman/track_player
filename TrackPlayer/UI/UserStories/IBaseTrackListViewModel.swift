//
//  IBaseTrackListViewModel.swift
//  TrackPlayer
//
//  Created by Dmitry on 13.01.2024.
//

import Foundation

protocol IBaseTrackListViewModel: ObservableObject {
    var container: DiContainer {get}
    
    /// UI state machine
    var stateMachine: ViewStateMachine<[TrackSong]?> {get}
    
    func onFirstAppear()
    
    var playingTrack: TrackSong? {get}
    var isPlayerPlayed: Bool  {get set}
    var tracks: [TrackSong] {get}
    
    func selectTrack(_ track: TrackSong)
    func stopPlayer()
    func playTrack(_ track: TrackSong)
    func errorMessage(error: Error?) -> String?
}

protocol BaseTrackListViewOutput: AnyObject {}
