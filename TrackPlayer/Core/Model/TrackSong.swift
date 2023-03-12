//
//  Song.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation

/// Track song model
struct TrackSong: Identifiable, Equatable{
    
    var id: String{
        return trackUrlString
    }
    
    let trackTitle: String?
    let artistTitle: String?
    
    let imageUrlString: String?
    let trackUrlString: String
    
    var imageUrl: URL? {
        guard let url = imageUrlString else {return nil}
        return URL.init(string: url)
    }
    
    var trackUrl: URL? {
        return URL.init(string: trackUrlString)
    }
}

extension TrackSong: Decodable{
    
    //It is optional for case when model's fileds are different
    enum CodingKeys: String,  CodingKey{

        case trackTitle = "trackName"
        case artistTitle = "artistName"
        case imageUrlString = "artworkUrl100"
        case trackUrlString = "previewUrl"
    }
}
