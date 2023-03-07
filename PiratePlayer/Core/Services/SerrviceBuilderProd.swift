//
//  SerrviceBuilderProd.swift
//  PiratePlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation


class ServiceBuilderProd: ServiceBuilderDebug{
   
    
    //MARK: - ServiceBuilder
    
    override var baseUrl: URL {
        return URL.init(string: Constants.Web.hostBaseProdURLString)!
    }
    
    override var analytics: Analytics {
        
        if _analytics == nil {
            //Here we can put array of analytics.
            //For example, debug, amplitude implamentation, firebase, e.t.c
            _analytics = HubAnalytics(analytics: [DebugAnalytic()])
        }
        
        return _analytics
    }
}
