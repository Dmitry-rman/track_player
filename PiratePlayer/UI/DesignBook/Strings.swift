//
//  Strings.swift
//  PiratePlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation

extension String {
    
    static func pallete(_ value: StringsPalette, bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(value.rawValue, tableName: tableName, bundle: bundle, value: "Missing localized **\(self)**", comment: "")
    }
    
    /// Палитра текстов в приложении
    enum StringsPalette: String {
        
        case songsListScreenTitle = "songs_list_title"
        
        case searchTitle = "search_song"
        
        case searchPromt = "search_promt"
        
        case startLoading = "start_loading"
        
        case closeSongButtonTitle = "close_song_button"
        
        case songTitle = "song_title"
        
        case artistTitle = "artist_title"
        
        case unknown = "unknown"
      
    }
}
