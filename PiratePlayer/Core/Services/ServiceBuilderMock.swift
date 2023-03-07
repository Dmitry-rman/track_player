//
//  ServiceBuilderMocks.swift
//  PiratePlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation

#if DEBUG
class ServiceBuilderMock: ServiceBuilder{
    
    var audioEngine: AudioEngineProtocol{
        return AudioEngine()
    }
    
    var baseUrl: URL {
        return URL.init(string: "https://google.com")!
    }
    
    func getSongsServie() -> SongService {
        SongsServiceMockImplementation()
    }
    
    lazy var analytics: Analytics = {
        DebugAnalytic()
    }()
    
}
#endif
