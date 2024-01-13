//
//  AppState.swift
//  TrackPlayer
//
//  Created by Dmitry on 12.03.2023.
//

struct AppState: Equatable {
    var userData: UserData
    
    static func == (lhs: AppState, rhs: AppState) -> Bool {
        return lhs.userData == rhs.userData
    }
}
