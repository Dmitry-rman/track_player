//
//  Analytics.swift
//  PiratePlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation

import Foundation

/// Analytycs system protocol
public protocol Analytics {
    
    func setUserId(_ userId: String?)
    func setUserProperty(_ value: String, forName name: String)
    func logEvent(_ event: CustomStringConvertible, properties: [String: Any]?)
    func onLogout()
}

extension Analytics{
    
    public func logEvent(_ event: CustomStringConvertible){
      logEvent(event, properties: nil)
    }
}
