//
//  Images.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import SwiftUI

/// Имена SFSymbols
enum SFSymbolsName: String {
    
    case cut = "scissors"
    case copy = "doc.on.doc"
    case paste = "doc.on.clipboard"
    case share = "square.and.arrow.up"
    case delete = "trash.fill"
    case closeIcon = "xmark"
    case backIcon = "arrow.left"
    case chevronUp = "chevron.up"
    case chevronDown = "chevron.down"
    case chevronRight = "chevron.right"
    case eye
    case search = "magnifyingglass"
    case check = "checkmark"
    case waveformCircle = "waveform.circle"
    case playCircle = "play.circle"
    case pauseCircleFill = "pause.circle.fill"
    case favoriteOff = "heart"
    case favoriteOn = "heart.fill"
    
    // здесь можно для некоторых символов переопределить названия, если они разные в разных системах
    fileprivate var systemName: String {
        
        switch self {
        default:
            return rawValue
        }
    }
}

extension Image {
    
    /// Создать иконку из SFSymbols
    /// - Parameter name: имя нужного SFSymbols
    init(sfSymbolName name: SFSymbolsName) {
        self.init(systemName: name.systemName)
    }
}


/// Названия картинок
enum ImageAssetName: String {
    
    // Icons from asset
    case spinner = "spinner"
    
}

extension Image {
    
    /// Create Image
    /// - Parameter name: image name
    init(assetsName name: ImageAssetName) {
        self.init(name.rawValue, bundle: .main)
    }
}
