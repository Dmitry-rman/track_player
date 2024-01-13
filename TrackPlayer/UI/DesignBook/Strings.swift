//
//  Strings.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation

extension String {
    
    static func pallete(_ value: StringsPalette, bundle: Bundle = .main, tableName: String = "Localizable") -> String 
    {
        return NSLocalizedString(value.rawValue, tableName: tableName, bundle: bundle, value: "Missing localized **\(self)**", comment: "")
    }
    
    /// Палитра текстов в приложении
    enum StringsPalette: String {
        case aboutButtonTitle = "about_button_title"
        case appDescription = "app_description"
        case songsListScreenTitle = "songs_list_title"
        case searchTitle = "search_song"
        case searchPromt = "search_promt"
        case startLoading = "start_loading"
        case closeSongButtonTitle = "close_song_button"
        case songTitle = "song_title"
        case artistTitle = "artist_title"
        case unknown = "unknown"
        case noTracksFound = "no_tracks_found"
        case noFavoritesFound = "no_favorites_found"
        case imageLoadingError = "image_loading_error"
        case volume = "volume"
        case currentTime = "current_time"
        case leftTime = "left_time"
        case noTrack = "no_track"
        case favorites = "favorites"
        case closeButton = "close_button"
        case pullToRefeshTitle = "refresh_title"
    }
}
