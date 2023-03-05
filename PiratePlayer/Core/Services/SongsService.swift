//
//  SongsService.swift
//  PiratePlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Combine

/// Songs service protocol
protocol SongService{
    
    func loadRecentSongs() -> AnyPublisher<[TrackSong], Error>
    func getSongs(byQuery query: String) -> AnyPublisher<[TrackSong], Error>
}
