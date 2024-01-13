//
//  SongsListViewModelProtocol.swift
//  TrackPlayer
//
//  Created by Dmitry on 05.03.2023.
//

import Foundation

protocol TrackListViewModelProtocol: IBaseTrackListViewModel {
    var onShowPlayer: ((_ isShowed: Bool)->())? { get set }
   
    var searchQuery: String {get set}
    var searching: Bool {get set}
    var output: TrackListViewModuleOutput? {get}
    
    func clearSearch()
}
