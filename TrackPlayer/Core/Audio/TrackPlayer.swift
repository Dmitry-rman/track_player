//
//  AppTrackPlayer.swift
//  TrackPlayer
//
//  Created by Dmitry on 15.03.2023.
//

import Foundation
import Combine

class TrackPlayer: ObservableObject{
    @Published private(set) var playingTrack: TrackSong?
    @Published private(set) var isPlaying: Bool = false
    @Published private(set) var duration: Int?
    @Published private(set) var time: Int = 0
    @Published var volume: Float = UserPreferences.volume
    
    private let _player: SoundPlayer
    private var cancellableSet = Set<AnyCancellable>()
    
    init(player: SoundPlayer) {
        var player = player
        _player = player
        
        player.isPlayingCahnged = { [weak self] value in
            self?.isPlaying = value
        }
        
        player.timeChanged = { [weak self] value in
            self?.time = value
        }
        
        player.onReadyToPlayChanged = { [weak self] duration in
            self?.duration = duration
        }

        $volume
            .sink { [weak self] value in
                UserPreferences.volume = value
                self?._player.setVolume(value)
            }
            .store(in: &cancellableSet)
    }
    
    func playTrack(_ track: TrackSong, fromBegin: Bool = true) {
        if playingTrack == track {
            _player.play(url: track.trackUrl, fromBegin: false)
        } else {
            _player.play(url: track.trackUrl, fromBegin: fromBegin)
            _player.setVolume(self.volume)
            playingTrack = track
        }
    }
    
    func pause() {
        _player.pause()
    }
    
    func resume() {
        _player.resume()
    }
    
    func stop() {
        _player.stop()
    }
}

extension TrackPlayer {
    static var preview: TrackPlayer {
        return TrackPlayer(player: AVSoundPlayer())
    }
}
