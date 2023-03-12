//
//  SongsListViewModelProtocol.swift
//  TrackPlayer
//
//  Created by Dmitry on 05.03.2023.
//

import Foundation

protocol TrackListViewModelProtocol: ObservableObject{
    
    var container: DiContainer {get}
    
    var player: AVSoundPlayer? {get}
    var playingTrack: TrackSong? {get}
    var onShowPlayer: ((_ isShowed: Bool)->())? {get set}
    var isPlayerPlayed: Bool  {get set}
    
    /// UI state machine
    var stateMachine: ViewStateMachine<[TrackSong]?> { get }
    
    var searchQuery: String {get set}
    var searching: Bool {get set}
    
    func startScenario()
    func selectTrack(_ song: TrackSong)
    func clearSearch()
    func stopPlayer()
    func trackDidPlayed(track: TrackSong, withPlayer player: AVSoundPlayer?)
    func errorMessage(error: Error?) -> String?
}

extension TrackListViewModelProtocol {
    
    func trackDidPlayed(track: TrackSong){
        trackDidPlayed(track: track, withPlayer: nil)
    }
}
