//
//  ServiceBuilderDebug.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation

class ServiceBuilderDebug: ServiceBuilder{
    
    let shouldLogNetworkRequests: Bool
    
    init(shouldLogNetworkRequests: Bool) {
        self.shouldLogNetworkRequests = shouldLogNetworkRequests
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
}
