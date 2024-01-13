//
//  DiContainer+Mock.swift
//  TrackPlayer
//
//  Created by Dmitry on 13.01.2024.
//

import Foundation

#if DEBUG
extension DiContainer {
    static var preview: DiContainer {
        return DiContainer.init(buildConfiguration: .testing)
    }
}
#endif
