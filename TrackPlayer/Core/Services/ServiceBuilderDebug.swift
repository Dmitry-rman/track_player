//
//  ServiceBuilderDebug.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation

class ServiceBuilderDebug: ServiceBuilder{
    
    private unowned var stateChanger: StateChangeProtocol?
    
    let shouldLogNetworkRequests: Bool
    
    init(shouldLogNetworkRequests: Bool, stateChanger: StateChangeProtocol) {
        
        self.shouldLogNetworkRequests = shouldLogNetworkRequests
        self.stateChanger = stateChanger
    }
    
    //MARK: - ServiceBuilder
    
    var baseUrl: URL {
        return URL.init(string: Constants.Web.hostBaseDebugURLString)!
    }
    
    func getSongsServie() -> SongService {
        SongServiceImplementation(baseUrl: self.baseUrl)
    }
    
    private var _audioEngine: AudioEngineProtocol!
    func getAudioEngine() -> AudioEngineProtocol{
        
        if _audioEngine == nil {
            _audioEngine = AudioEngine()
        }
        return _audioEngine
    }
    
    internal var _analytics: Analytics!
    var analytics: Analytics{
        if _analytics == nil {
            _analytics = DebugAnalytic()
        }
        return _analytics
    }
    
    private var _favoriteStore: FavoritesStore!
    func getFavoritesService() ->  any FavoritesStore{
        
        if let favoriteStore = _favoriteStore {
            return favoriteStore
        }else{
          _favoriteStore = FaforitesStoreImplementation(stateChanger: stateChanger)
            return _favoriteStore
        }
    }
    
    func createPlayer() -> TrackPlayer {
        return TrackPlayer(player: AVSoundPlayer())
    }
}
