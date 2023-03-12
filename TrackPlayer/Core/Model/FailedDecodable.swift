//
//  FailedDecodable.swift
//  TrackPlayer
//
//  Created by Dmitry on 05.03.2023.
//

import Foundation

struct FailableDecodable<Base : Decodable> : Decodable {

    let base: Base?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try? container.decode(Base.self)
    }
}
