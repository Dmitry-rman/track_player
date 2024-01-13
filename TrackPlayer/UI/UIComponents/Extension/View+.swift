//
//  View+.swift
//  Portable
//  Created by Dmitry on 23.12.2023.
//

import SwiftUI

extension View {
    @ViewBuilder
    public func `if`(_ conditional: Bool, content: (Self) -> some View) -> some View {
        if conditional {
            content(self)
        } else {
            self
        }
    }

    @ViewBuilder
    public func `do`(content: (Self) -> some View) -> some View {
        content(self)
    }
    
    func padding(_ edges: Edge.Set = .all, _ paddings: Paddings) -> some View {
        self.padding(edges, paddings.rawValue)
    }
}
