//
//  SerrviceBuilderProd.swift
//  PiratePlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation


class ServiceBuilderProd: ServiceBuilder{
    
    let shouldLogNetworkRequests: Bool
    
    init(shouldLogNetworkRequests: Bool) {
        self.shouldLogNetworkRequests = shouldLogNetworkRequests
    }
    
    //MARK: - ServiceBuilder
    
    var baseUrl: URL {
        return URL.init(string: Constants.Web.hostBaseProdURLString)!
    }
    
    func getSongsServie() -> SongService {
        SongServiceImplementation(baseUrl: self.baseUrl)
    }
    
    lazy var analytics: Analytics = {
        
        //Here we can put array of analytics.
        //For example, debug, amplitude implamentation, firebase, e.t.c
        return HubAnalytics(analytics: [DebugAnalytic()])
    }()
}
