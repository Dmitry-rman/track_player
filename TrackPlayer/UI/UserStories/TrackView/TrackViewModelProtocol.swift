//
//  SongViewModelProtocol.swift
//  TrackPlayer
//
//  Created by Dmitry on 05.03.2023.
//

import Foundation

protocol TrackViewModelProtocol: ObservableObject{
    
    /// UI state machine
    var stateMachine: ViewStateMachine<TrackSong> {get}
    
    func startScenario()
    
    var trackTitle: String {get}
    var artistTitle: String {get}
    var imageUrl: URL? {get}
    var songUrl: URL? {get}
    var isFavorited: Bool {get}
    var player: TrackPlayer {get}
    
    func toggleFavorite() 
    var timeString: String {get}
    var leftTimeString: String {get}
    func playTap()
    func closeAction()
    
}
