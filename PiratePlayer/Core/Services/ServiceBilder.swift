//
//  ServiceBilder.swift
//  PiratePlayer
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
    var audioEngine: AudioEngineProtocol {get}
    
    /// Get analytics
    var analytics: Analytics { get }
}
