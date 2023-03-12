//
//  PlayerViewModel.swift
//  TrackPlayer
//
//  Created by Dmitry on 05.03.2023.
//

import Combine

class PlayerViewModel: ObservableObject{
    
    let track: TrackSong?
    @Published private(set) var isFavorited: Bool = false
    
    private var cancellableSet = Set<AnyCancellable>()
    private let container: DiContainer
    
    var trackExist: Bool{
        return track != nil
    }
    
    var songTitle: String {
        guard let track else {return String.pallete(.noTrack)}
        return  "\(track.trackTitle  ?? String.pallete(.unknown))"
    }
    
    var artistTitle: String {
        guard let track else {return ""}
        return "\(track.artistTitle ?? String.pallete(.unknown))"
    }
    
    func timeString(player: AVSoundPlayer) -> String{
        
        guard let duration = player.duration else {return " 00:00"}
        
        let seconds = duration - player.time
        return String(format: "-%02d:%02d", seconds/60, seconds%60) as String//"\(secs/60):\(secs%60)"
    }
    
    init(diContainer: DiContainer, track: TrackSong?) {
        
        self.track = track
        self.container = diContainer
        
        container.appState
            .map({ [weak self] value in
                return value.userData.favorites.contains{
                    $0 == self?.track?.trackUrlString
                }
            })
            .sink(receiveValue: { [weak self] value in
                self?.isFavorited = value
            })
            .store(in: &cancellableSet)
    }
    
    func toggleFavorite() {
        
        if isFavorited {
            if let track = self.track{
                container.appState.value.userData.removeTrackFromFavorites(track)
            }
        }else{
            if let track = self.track{
                container.appState.value.userData.addTrackToFavorits(track)
            }
        }
    }
    
    deinit{
        debugPrint("deinit \(Self.self)")
    }
}
