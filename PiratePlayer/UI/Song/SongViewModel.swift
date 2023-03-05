//
//  SongViewModel.swift
//  PiratePlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation
import Combine

protocol SongViewModelProtocol: ObservableObject{
    
    /// UI state machine
    var stateMachine: ViewStateMachine<TrackSong> {get}
    
    func startScenario()
    
    var songTitle: String {get}
    var artistTitle: String {get}
    var imageUrl: URL? {get}
    var songUrl: URL? {get}
    
    func closeAction()
    func playTap()
}

///Вью модель экрана песни
final class SongViewModel: SongViewModelProtocol{

    var songTitle: String {
        
        switch stateMachine.state{
        case .content(let track, _):
            return "\(String.pallete(.songTitle)) \(track.trackTitle  ?? String.pallete(.unknown))"
        default:
            return ""
        }
    }
    
    var artistTitle: String {
        
        switch stateMachine.state{
        case .content(let track, _):
            return "\(String.pallete(.artistTitle)) \(track.artistTitle ?? String.pallete(.unknown))"
        default:
            return ""
        }
    }
    
    var imageUrl: URL?{
        
        switch stateMachine.state{
        case .content(let track, _):
            return track.imageUrl
        default:
            return nil
        }
    }
    
    var songUrl: URL?{
        
        switch stateMachine.state{
        case .content(let track, _):
            return track.trackUrl
        default:
            return nil
        }
    }
    
    private(set) var stateMachine: ViewStateMachine<TrackSong>
    private var stateCancellable: AnyCancellable?
    private var isScenarioStarted = false
    
    private let songService: SongService
    private let analytics: Analytics
    
    private weak var output: SongViewModuleOutput?
    
    convenience init(song: TrackSong, output: SongViewModuleOutput, container: DiContainer){
        
        self.init(state: .content(song, .default), container: container)
        self.output = output
    }
    
    init(state: ViewState<TrackSong>, container: DiContainer){
        
        self.songService = container.serviceBuilder.getSongsServie()
        self.analytics = container.serviceBuilder.analytics
        
        self.stateMachine = ViewStateMachine(state)
        stateCancellable = stateMachine.$state.sink { [weak self] state in

            self?.objectWillChange.send()
        }
        
    }
    
    func startScenario(){
        
        guard !isScenarioStarted else { return }
        isScenarioStarted = true
        
        self.stateMachine.setState(.loading)
        
    }
    
    func closeAction(){
        
        //Example for closing action by Coordinator
        self.output?.songViewDidClosed()
    }
    
    func playTap(){
        
        var selectedTrackName: String?
        switch stateMachine.state{
        case .content(let track, _):
            selectedTrackName = track.trackTitle
        default:
            break
        }
        
        //send analytics
        if let trackName = selectedTrackName {
            self.analytics.logEvent(AppEventAnalytics.select_track,
                                    properties: ["name" : trackName])
        }else{
            self.analytics.logEvent(AppEventAnalytics.select_track)
        }
    }
    
    deinit{
        debugPrint("deinit \(Self.self)")
    }
}
