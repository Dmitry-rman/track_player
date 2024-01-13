//
//  ButtonStyles.swift
//  Created by Dmitry on 09.04.2023.
//

import Foundation
import SwiftUI

struct AppPrimaryButtonStyle: ButtonStyle {
    
    private let cornerRadius: CGFloat
    let height: CGFloat
    let color: Color?
    let textColor: Color?
    
    init(cornerRadius: CGFloat? = nil,
         height: CGFloat? = nil,
         color: Color? = nil,
         textColor: Color? = nil)
    {
        self.cornerRadius = cornerRadius ?? 12.0
        #if os(macOS)
        self.height = height ?? 33.0
        #else
        self.height = height ?? 44.0
        #endif
        self.color = color
        self.textColor = textColor
    }
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        AppPrimaryButton(configuration: configuration,
                         cornerRadius: cornerRadius,
                         color: color,
                         textColor: textColor)
        .frame(height: height)
    }
}

struct AppPrimaryRoundedButtonStyle: ButtonStyle {
    private let cornerRadius: CGFloat = 100
    let height: CGFloat
    
    init(height: CGFloat? = nil) {
        self.height = height ?? 44.0
    }
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        AppPrimaryButton(configuration: configuration,
                         cornerRadius: cornerRadius,
                         color: nil,
                         textColor: nil)
    }
}

struct AppPrimaryButton: View {
    let configuration: ButtonStyle.Configuration
    let cornerRadius: CGFloat
    let color: Color?
    let textColor: Color?
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    init(configuration: ButtonStyle.Configuration,
         cornerRadius: CGFloat,
         color: Color?,
         textColor: Color?) {
        self.configuration = configuration
        self.cornerRadius = cornerRadius
        self.color = color
        self.textColor = textColor
    }
    
    @ViewBuilder
    var body: some View {
        self.content
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
    
    private var content: some View {
        configuration.label
            .padding(.vertical, 8)
            //.font(Font.fromAsset(type: .buttonBasicText))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(self.textColor(isPressed: configuration.isPressed))
            .background(isEnabled == true ? (color ?? Color(.buttonPrimaryBackground)) : Color(.buttonPrimaryBackgroundDisabled))
            .cornerRadius(cornerRadius)
    }
    
    private func textColor(isPressed: Bool) -> Color {
        let color = textColor ?? Color(.buttonPrimaryForeground)
        return isPressed == true ? color.opacity(0.7) : color
    }
}

struct AppSecondaryButtonStyle: ButtonStyle {
    
    let height: CGFloat
    
    init(height: CGFloat? = nil) {
        self.height = height ?? 44.0
    }
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        AppSecondaryButton(configuration: configuration, height: height)
    }
}

struct AppSecondaryButton: View {
    
    let configuration: ButtonStyle.Configuration
    @Environment(\.isEnabled) private var isEnabled: Bool
    let height: CGFloat
    
    
    @ViewBuilder
    var body: some View {
        self.content
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
    
    private var content: some View {
        configuration.label
            //.font(Font.fromAsset(type: .buttonBasicText))
            .frame(maxWidth: .infinity)
            .foregroundColor(self.textColor)
            .frame(height: height)
    }
    
    private var textColor: Color {
        let color = Color(.buttonTertiaryForeground)
        return isEnabled == true ? color : color.opacity(0.5)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
