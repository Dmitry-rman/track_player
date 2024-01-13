//
//  File.swift
//  TrackPlayer
//
//  Created by Dmitry on 08.03.2023.
//

import Foundation

enum AppError: Error, LocalizedError {
    case apiError(reason: String)
    case unknown
    
    var errorDescription: String?{
        switch self{
        case .apiError(let reason):
            return reason
        case .unknown:
            return String.pallete(.unknown)
        }
    }
}
