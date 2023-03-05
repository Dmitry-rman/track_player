//
//  AppAnalytics.swift
//  PiratePlayer
//
//  Created by Dmitry on 05.03.2023.
//

import Foundation

public enum AppEventAnalytics: String, CustomStringConvertible{
    
    case app_close = "App Close"
    case launch_first_time = "Launch First Time"
    case launch_other_time = "Launch Other Time"
    
    case registration_start = "Clicks Create Account"
    case registration_enters_info = "Enters Info"
    case registration_completed = "Account Created"
    case registration_failed = "Registration failed"
    case remove_account = "Account Removed"
    
    case login_started = "Clicks Sign In"
    case login_success = "Login Success"
    case login_failed = "Login Fail"
    case recovery_started = "Recover Account"
    
    case main_screen_visited = "Main Screen Visited"
    case notifications_allowed = "Notifications Allowed"
    
    case select_track = "Select track"
    case play_track = "Play track"
    
    public  var description: String{
        return self.rawValue
    }
}
