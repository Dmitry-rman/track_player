//
//  PlayerViewModel.swift
//  TrackPlayer
//
//  Created by Dmitry on 05.03.2023.
//

import Foundation
import Combine

class PlayerViewModel: ObservableObject{
    
    @Published var player: TrackPlayer
    
    @Published private(set) var isFavorited: Bool = false
    
    private var cancellableSet = Set<AnyCancellable>()
    let container: DiContainer
    
    var trackExist: Bool{
        return player.playingTrack != nil
    }
    
    var volume: String{
        String(format: "%.f%%", player.volume)
    }
    
    var songTitle: String {
        guard let track = player.playingTrack else {return String.pallete(.noTrack)}
        return  "\(track.trackTitle  ?? String.pallete(.unknown))"
    }
    
    var artistTitle: String {
        guard let track = player.playingTrack else {return ""}
        return "\(track.artistTitle ?? String.pallete(.unknown))"
    }
    
    func timeString() -> String{
        
        guard let duration = player.duration else {return " 00:00"}
        
        let seconds = duration - player.time
        return String(format: "-%02d:%02d", seconds/60, seconds%60) as String//"\(secs/60):\(secs%60)"
    }
    
    init(diContainer: DiContainer) {
        
        self.container = diContainer
        self.player = diContainer.player
        
        container.appState
            .flatMap { [weak self] state -> AnyPublisher<Bool, Never> in
              
                guard let self = self, let track = self.player.playingTrack else {
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                }
                
                return self.container.serviceBuilder.getFavoritesService()
                    .isTrackFavorited(track)
                    .eraseToAnyPublisher()
            }
            .assign(to: &$isFavorited)
        
        container.player.$time
            .map{ [weak self] value in
                self?.objectWillChange.send()
                return value
            }
            .sinkStore(in: &cancellableSet)
        
        container.player.$playingTrack
            .flatMap {  [weak self] track -> AnyPublisher<Bool, Never> in
                
                guard let self = self, let track = track else {
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                }
                
                return self.container.serviceBuilder.getFavoritesService()
                    .isTrackFavorited(track)
                    .eraseToAnyPublisher()
            }
            .assign(to: &$isFavorited)
    }
    
    func toggleFavorite() {
        
        let service = container.serviceBuilder.getFavoritesService()
        if isFavorited {
            if let track = player.playingTrack{
                service.removeTracksFromFavorites([track])
                    .sinkStore(in: &cancellableSet)
            }
        }else{
            if let track = player.playingTrack{
                service.addTrackToFavorits(track)
                    .sinkStore(in: &cancellableSet)
            }
        }
    }
    
    func playTap(){
        
        if player.isPlaying == true {
            player.pause()
        }else if let track = player.playingTrack{
            player.playTrack(track, fromBegin: false)
        }
    }
    
    deinit{
        debugPrint("deinit \(Self.self)")
    }
}
