//
//  Mocks.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation

#if DEBUG
/// Songs mocks
extension TrackSong{
    static var mocked: TrackSong {
        TrackSong(trackTitle: "Song 1",
                  artistTitle: "Artist 1",
                  imageUrlString: "https://google.com/song_images?id=1",
                  trackUrlString: "https://google.com/songs?id=1")
    }
    
    static var mockedSongs: [TrackSong] {
         [
            TrackSong(trackTitle: "Song 1",
                      artistTitle: "Artist 1",
                      imageUrlString: "https://google.com/song_images?id=1",
                      trackUrlString: "https://google.com/songs?id=1"),
            TrackSong(trackTitle: "Song 2",
                      artistTitle: "Artist 2",
                      imageUrlString: "https://google.com/song_images?id=2",
                      trackUrlString: "https://google.com/songs?id=2"),
            TrackSong(trackTitle: "Song 2",
                      artistTitle: "Artist 2",
                      imageUrlString: "https://google.com/song_images?id=3",
                      trackUrlString: "https://google.com/songs?id=3")
        ]
    }
}
#endif
