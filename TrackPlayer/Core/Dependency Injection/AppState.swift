//
//  AppState.swift
//  TrackPlayer
//
//  Created by Dmitry on 12.03.2023.
//

import Foundation

struct AppState: Equatable {
    
    var userData: UserData
    
    static func == (lhs: AppState, rhs: AppState) -> Bool {
        return lhs.userData == rhs.userData
    }
}

protocol StateChangeProtocol: AnyObject{
    
    func favoritsChanged(_ value: Int)
}
