//
//  SongsServiceMockImplementation.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation
import Combine

#if DEBUG
class SongsServiceMockImplementation: SongService{
    
    func getSongs(byQuery query: String, limit: Int) -> AnyPublisher<[TrackSong], Error> {
        
        return Just([TrackSong.mockedSongs.first!])
            .setFailureType(to: Error.self)
            .delay(for: 0.2, scheduler: DispatchQueue.global(qos: .userInitiated))
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func loadRecentSongs() -> AnyPublisher<[TrackSong], Error> {
      
        return Just(TrackSong.mockedSongs)
            .setFailureType(to: Error.self)
            .delay(for: 2.0, scheduler: DispatchQueue.global(qos: .userInitiated))
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
#endif
