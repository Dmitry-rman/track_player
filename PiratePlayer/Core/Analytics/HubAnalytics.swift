//
//  HubAnalytics.swift
//  PiratePlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation

///Hub analytics contains other analytocs as array
final public class HubAnalytics: Analytics{

    let _analytics: [Analytics]!
    
    public init(analytics: [Analytics]){
        _analytics = analytics
    }
    
    public func setUserId(_ userId: String?) {
        _analytics.forEach { analytic in
            analytic.setUserId(userId)
        }
    }
    
    public func setUserProperty(_ value: String, forName name: String) {
        _analytics.forEach { analytic in
            analytic.setUserProperty(value, forName: name)
        }
    }
    
    public func onLogout() {
        _analytics.forEach { analytic in
            analytic.onLogout()
        }
    }
    
    public func logEvent(_ event: CustomStringConvertible, properties: [String : Any]? = nil) {
        _analytics.forEach { analytic in
            analytic.logEvent(event, properties: properties)
        }
    }
}

final public class StubHubAnalytics: Analytics {
    
    public init(){
        
    }
    
    public func logEvent(_ event: CustomStringConvertible, properties: [String : Any]?) {
        print("logEvent " + event.description + " \(properties ?? [:])")
    }
    
    public func setUserId(_ userId: String?) {
        print("setUserId event userId=\(userId ?? "nil")")
    }
    
    public func setUserProperty(_ value: String, forName name: String) {
        print("setUserProperty event \(name)=\(value)")
    }
    
    public func onLogout() {
        print("onLogout event")
    }
}
