//
//  SongsService.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Combine

/// Tracks service protocol
protocol SongService{
    
    func loadRecentSongs() -> AnyPublisher<[TrackSong], Error>
    func getSongs(byQuery query: String, limit: Int) -> AnyPublisher<[TrackSong], Error>
}
