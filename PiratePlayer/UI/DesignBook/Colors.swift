//
//  Colors.swift
//  PiratePlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation

import SwiftUI

/// Color assets
enum ColorAssetName: String {
    
    case accent
    
    case backgroundBasic
    case backgroundPrimary
    case backgroundDeep
    case backgroundCard
    
    case buttonPrimaryBackground
    case buttonPrimaryForeground
    case buttonTertiaryForeground
    case buttonPrimaryBackgroundDisabled
    
    case headerTitle
    case headerSubtitle
    
    case inputValue
    case inputPlaceholder
    case inputBorderActive
    case inputBorder
    case inputError
    case inputBackground
    case inputBackgroundDisabled
    
    case iconBasic
    case lightIconSecondary
    
    case textPrimary
    case textSecondary
    case textLink
    
    case modalBackgroundTint
}

extension Color {
    
    /// Create color
    /// - Parameter name: color name
    init(assetsName name: ColorAssetName) {
        self.init(name.rawValue,
                  bundle: .main) //change this Bundle if you have  resources in external Bundle
    }
}

extension UIColor {
    
    /// Create color
    /// - Parameter name: color name
    convenience init?(assetsName name: ColorAssetName) {
        self.init(named: name.rawValue,
                  in: .main, //change this Bundle if you have  resources in external Bundle
                  compatibleWith: nil)
    }
}
