//
//  SongViewModel.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation
import Combine

///Вью модель экрана песни
final class TrackViewModel: TrackViewModelProtocol{
    
    @Published private(set) var isFavorited: Bool = false
    
    private var cancellableSet = Set<AnyCancellable>()
    private let container: DiContainer
    
    var trackTitle: String {
        
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
        self.container = container
        
        self.stateMachine = ViewStateMachine(state)
        stateCancellable = stateMachine.$state.sink { [weak self] state in
            
            self?.objectWillChange.send()
        }
        
        self.container.appState
            .map({ [weak self] value in
                return value.userData.favorites.contains{
                    
                    var trackID: String?
                    switch self?.stateMachine.state{
                    case .content(let track, _):
                        trackID = track.id
                    default:
                        break
                    }
                    
                    return $0 == trackID
                }
            })
            .sink(receiveValue: { [weak self] value in
                self?.isFavorited = value
            })
            .store(in: &cancellableSet)
        
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
    
    func playTap(player: AVSoundPlayer){
        
        var selectedTrack: TrackSong?
        
        switch stateMachine.state{
        case .content(let track, _):
            selectedTrack = track
            self.output?.playerDidPlay(track: track, withPlayer: player)
        default:
            break
        }
        
        //MARK: - Analytics
        //Send analytics
        if let trackName = selectedTrack?.trackTitle {
            self.analytics.logEvent(AppEventAnalytics.select_track,
                                    properties: ["name" : trackName])
        }else{
            self.analytics.logEvent(AppEventAnalytics.select_track)
        }
    }
    
    func leftTimeString(player: AVSoundPlayer) -> String {
        
        guard let duration = player.duration else {return ""}
        
        let seconds = duration - player.time
        return String(format: "-%02d:%02d", seconds/60, seconds%60) as String//"\(secs/60):\(secs%60)"
    }
    
    func timeString(player: AVSoundPlayer) -> String {
        
        let seconds = player.time
        return String(format: "%02d:%02d", seconds/60, seconds%60) as String//"\(secs/60):\(secs%60)"
    }
    
    func toggleFavorite() {
        
        switch self.stateMachine.state{
        case .content(let track, _):
            if isFavorited {
                container.appState.value.userData.removeTrackFromFavorites(track)
            }else{
                container.appState.value.userData.addTrackToFavorits(track)
            }
        default:
            break
        }
  
    }
    
    deinit{
        debugPrint("deinit \(Self.self)")
    }
}
