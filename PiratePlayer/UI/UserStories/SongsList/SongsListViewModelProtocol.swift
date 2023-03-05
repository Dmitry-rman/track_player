//
//  SongsListViewModelProtocol.swift
//  PiratePlayer
//
//  Created by Dmitry on 05.03.2023.
//

import Foundation

protocol SongsListViewModelProtocol: ObservableObject{
    
    /// UI state machine
    var stateMachine: ViewStateMachine<[TrackSong]?> { get }
    
    var searchQuery: String {get set}
    var searching: Bool {get set}
    
    func startScenario()
    func selectTrack(_ song: TrackSong)
    func clearSearch()
}
