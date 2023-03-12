//
//  TrackSerachResponse.swift
//  TrackPlayer
//
//  Created by Dmitry on 05.03.2023.
//

import Foundation

struct TrackSerachResponse: Decodable{
    
    let results: [TrackSong]
    let resultCount: Int
    
    enum CodingKeys: CodingKey {
        case results
        case resultCount
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try container.decode([FailableDecodable<TrackSong>].self, forKey: .results).compactMap { $0.base }
        self.resultCount = try container.decode(Int.self, forKey: .resultCount)
    }
}
