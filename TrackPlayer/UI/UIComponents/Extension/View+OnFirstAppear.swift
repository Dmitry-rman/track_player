//
//  View+OnFirstAppear.swift
//
//  Created by Dmitry on 07.01.2024.
//

import SwiftUI

struct OnFirstAppearModifier: ViewModifier {
    let perform: () -> Void
    @State private var firstTime: Bool = true

    func body(content: Content) -> some View {
        content
            .onAppear {
                if firstTime {
                    firstTime = false
                    perform()
                }
            }
    }
}

extension View {
    public func onFirstAppear(perform: @escaping () -> Void) -> some View {
        modifier(OnFirstAppearModifier(perform: perform))
    }
}
