//
//  ServiceBuilderMocks.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation

#if DEBUG
class ServiceBuilderMock: ServiceBuilder{
    func getFavoritesService() ->  any FavoritesStore{
        FaforitesStoreImplementation(stateChanger: nil)
    }
    
    func getAudioEngine() ->  IAudioEngine {
        return AudioEngine()
    }
    
    var baseUrl: URL {
        return URL.init(string: "https://google.com")!
    }
    
    func getSongsServie() -> SongService {
        SongsServiceMockImplementation()
    }
    
    func createPlayer() -> TrackPlayer {
        return TrackPlayer(player: AVSoundPlayer())
    }
    
    lazy var analytics: Analytics = {
        DebugAnalytic()
    }()
}
#endif
