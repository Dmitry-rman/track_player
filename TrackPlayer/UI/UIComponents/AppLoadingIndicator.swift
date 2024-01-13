//
//  AppLoadingIndicator.swift
//
//  Created by Dmitry on 08.01.2024.
//

import SwiftUI

struct AppLoadingIndicator: View {
    let type: LoadingIndicatorType
    let title: LocalizedStringKey?
    
    private let backgroundColor = Color.black.opacity(0.5)
    private let size: Double = 33.0
    private let foregroundColor = Color.white
    
    init(
        type: LoadingIndicatorType = .image(Image.init(assetsName: .spinner)),
        title: LocalizedStringKey? = nil)
    {
        self.type = type
        self.title = title
    }
    
    var body: some View {
        if let title {
            VStack {
                LoadingIndicator(type: type,
                                 size: size,
                                 color: foregroundColor,
                                 backgroundColor: .clear)
                Text(title)
                    .foregroundColor(foregroundColor)
            }
            .padding(.all, .medium)
            .background(backgroundColor)
            .cornerRadius(8.0)
        } else {
            LoadingIndicator(type: type,
                             size: size,
                             color: foregroundColor,
                             backgroundColor: backgroundColor)
        }
    }
}
