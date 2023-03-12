//
//  DebugAnalytics.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation

///Debug analytic implementation
public class DebugAnalytic: Analytics{
    
    public func logEvent(_ event: CustomStringConvertible, properties: [String : Any]?) {
        debugPrint("log event \(event.description)")
    }
    
    public func setUserId(_ userId: String?) {
        if let userId = userId {
            debugPrint("setUserId \(userId)")
        }
    }
    
    public func setUserProperty(_ value: String, forName name: String) {
        debugPrint("setUserProperty \(name): \(value)")
    }
    
    public func onLogout(){
        debugPrint("Logout")
    }
}
