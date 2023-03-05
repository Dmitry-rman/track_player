//
//  ServiceBuilderDebug.swift
//  PiratePlayer
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
    
    lazy var analytics: Analytics = {
        return DebugAnalytic()
    }()
}
