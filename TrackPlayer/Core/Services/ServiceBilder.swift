//
//  ServiceBilder.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation

/// Builder of app services
protocol ServiceBuilder {
    
    /// Base url for server
    var baseUrl: URL { get }
    
    /// Get songs service
    func getSongsServie() -> SongService
    
    /// Audio Engine service
    func getAudioEngine() -> AudioEngineProtocol
    
    /// Get analytics
    var analytics: Analytics { get }
}
