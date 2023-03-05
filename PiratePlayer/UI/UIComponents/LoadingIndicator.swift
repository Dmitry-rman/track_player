//
//  LoadingIndicator.swift
//  PiratePlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation
import SwiftUI

struct LoadingIndicator: View {
    
    @State private var rotationDegrees = 0.0
    
    private let size: CGSize
    
    init(size: CGSize? = nil) {
   
        self.size = size ?? .init(width: 80, height: 80)
    }
    
    private var animation: Animation {
        Animation.linear(duration: 1)
            .speed(0.5).repeatForever(autoreverses: false)
    }
    
    var body: some View {
        Image(assetsName: .spinner)
            .resizable()
            .renderingMode(.template)
            .foregroundColor(Color.init(assetsName: .accent))
            .rotationEffect(.degrees(rotationDegrees))
            .onAppear {
                withAnimation(self.animation) {
                        rotationDegrees = 360.0
                    }
            }
            .frame(width: size.width, height: size.height)
    }
}

#if DEBUG
struct AppLoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        HStack{
            LoadingIndicator(size: .init(width: 24, height: 24))
            Spacer()
        }
        .padding()
    }
}
#endif
