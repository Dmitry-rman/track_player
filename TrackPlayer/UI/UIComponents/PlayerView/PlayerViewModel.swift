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
    
    func timeString(player: AVSoundPlayer) -> String{
        
        guard let duration = player.duration else {return ""}
        
        let seconds = duration - player.time
        return String(format: "-%02d:%02d", seconds/60, seconds%60) as String//"\(secs/60):\(secs%60)"
    }
    
    init(track: TrackSong?) {
        self.track = track
    }
    
    deinit{
        debugPrint("deinit \(Self.self)")
    }
}
