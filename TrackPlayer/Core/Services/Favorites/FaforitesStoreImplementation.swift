//
//  UserDataInMemoryImplementation.swift
//  TrackPlayer
//
//  Created by Dmitry on 13.03.2023.
//

import Combine
import Foundation

/// Real User Data Service implementation
class FaforitesStoreImplementation: FavoritesStore {
    
    private let _serviceDelayImitation = 0.25
    private unowned var stateChanger: StateChangeProtocol?
    private var favorites = Set<TrackSong>()
    
    init(stateChanger: StateChangeProtocol?) {
        
        self.stateChanger = stateChanger
    }
    
    func getFavoritesCount() -> AnyPublisher<Int, Error> {
        
        let result = favorites.count
        return Just(result)
            .setFailureType(to: Error.self)
            .delay(for: .seconds(_serviceDelayImitation), scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func isTrackFavorited(_ track: TrackSong) -> AnyPublisher<Bool, Never> {
        
        let result =  favorites.contains{
            $0.id == track.id
        }
        return Just(result)
            .delay(for: .seconds(_serviceDelayImitation), scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    ///Add track to favorites
    func addTrackToFavorits(_ track: TrackSong) -> AnyPublisher<Bool, Error>{
        
        let result = favorites.insert(track).inserted
        
        return Just(result)
            .setFailureType(to: Error.self)
            .delay(for: .seconds(_serviceDelayImitation), scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .print()
            .map{ [weak self] value in
                guard let self = self else {
                    return value
                }
                if value == true {
                    self.stateChanger?.favoritsChanged(self.favorites.count)
                }
                return value
            }
            .eraseToAnyPublisher()
    }
    
    ///Remove track from favorite
    func removeTracksFromFavorites(_ tracks:  [TrackSong]) -> AnyPublisher<Bool, Error>{
        
        var result: Bool = (tracks.count > 0)
        tracks.forEach { track in
            result = result && (favorites.remove(track) != nil)
        }
        
        return Just(result)
            .setFailureType(to: Error.self)
            .delay(for: .seconds(_serviceDelayImitation), scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .map{ [weak self] value in
                guard let self = self else {return value}
                if value == true {
                    self.stateChanger?.favoritsChanged(self.favorites.count)
                }
                return value
            }
            .eraseToAnyPublisher()
    }
    
    func getFavorites() -> AnyPublisher<[TrackSong], Error>{
        
        return Just(Array(favorites))
            .setFailureType(to: Error.self)
            .delay(for: .seconds(_serviceDelayImitation), scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    deinit{
        debugPrint("deinit \(Self.self)")
    }
}
