//
//  PlayerViewModel.swift
//  TrackPlayer
//
//  Created by Dmitry on 05.03.2023.
//

import Foundation

class PlayerViewModel: ObservableObject{
    
    let track: TrackSong?
    
    var trackExist: Bool{
        return track != nil
    }
    
    var songTitle: String {
        guard let track else {return "No track"}
        return  "\(track.trackTitle  ?? String.pallete(.unknown))"
    }
    
    var artistTitle: String {
        guard let track else {return ""}
       return "\(track.artistTitle ?? String.pallete(.unknown))"
    }
    
    init(track: TrackSong?) {
        self.track = track
    }
    
    deinit{
        debugPrint("deinit \(Self.self)")
    }
}
