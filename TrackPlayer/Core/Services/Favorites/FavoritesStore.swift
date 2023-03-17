//
//  UserData.swift
//  TrackPlayer
//
//  Created by Dmitry on 12.03.2023.
//

import Foundation
import Combine

protocol FavoritesStore{
    
    func getFavoritesCount() -> AnyPublisher<Int, Error>
    
    func addTrackToFavorits(_ track: TrackSong) -> AnyPublisher<Bool, Error>
    func removeTracksFromFavorites(_ tracks: [TrackSong]) -> AnyPublisher<Bool, Error>
    
    func isTrackFavorited(_ track: TrackSong) -> AnyPublisher<Bool, Never>
    func getFavorites() -> AnyPublisher<[TrackSong], Error>
}

