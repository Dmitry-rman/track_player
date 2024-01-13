//
//  VStack+.swift
//  Portable
//  Created by Dmitry on 23.12.2023.
//

import SwiftUI

extension VStack {
    init(alignment: HorizontalAlignment = .center, 
         spacing: Paddings,
         @ViewBuilder content: () -> Content)
    {
        self.init(alignment: alignment,
                  spacing: spacing.rawValue,
                  content: content)
    }
}
