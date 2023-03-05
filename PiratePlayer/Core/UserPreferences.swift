//
//  UserPreferences.swift
//  PiratePlayer
//
//  Created by Dmitry on 05.03.2023.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    var key: String
    var initialValue: T
    var wrappedValue: T {
        set {
            UserDefaults.standard.set(newValue, forKey: key)
            UserDefaults.standard.synchronize()
        }
        get { UserDefaults.standard.object(forKey: key) as? T ?? initialValue }
    }
}

enum UserPreferences {
    @UserDefault(key: "isFirstAppStart", initialValue: true) static var isFirstAppStart: Bool
}
