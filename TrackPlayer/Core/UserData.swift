//
//  UserData.swift
//  TrackPlayer
//
//  Created by Dmitry on 12.03.2023.
//

import Foundation

protocol UserData{
    
    mutating func addTrackToFavorits(_ track: TrackSong)
    mutating func removeTrackFromFavorites(_ track: TrackSong)
}

extension AppState {
    
    struct RealUserData: UserData, Equatable {

        private(set) var favorites = Set<String>()
        
        ///Add track to favorites
        mutating func addTrackToFavorits(_ track: TrackSong) {
            
            favorites.insert(track.id)
        }
        
        ///Remove track from favorite
        mutating func removeTrackFromFavorites(_ track: TrackSong) {
           
            favorites.remove(track.id)
        }
    }
    
}
