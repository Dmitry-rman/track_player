//
//  SongViewModelProtocol.swift
//  PiratePlayer
//
//  Created by Dmitry on 05.03.2023.
//

import Foundation

protocol SongViewModelProtocol: ObservableObject{
    
    /// UI state machine
    var stateMachine: ViewStateMachine<TrackSong> {get}
    
    func startScenario()
    
    var songTitle: String {get}
    var artistTitle: String {get}
    var imageUrl: URL? {get}
    var songUrl: URL? {get}
    
    func closeAction()
    func playTap()
}
