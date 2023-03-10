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
    
    func timeString(player: AVSoundPlayer) -> String
    func leftTimeString(player: AVSoundPlayer) -> String
    func closeAction()
    func playTap(player: AVSoundPlayer)
}
