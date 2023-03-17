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
    @Published private(set) var player: TrackPlayer{
        didSet{
            subscribeToPlayerChanges()
        }
    }
    
    private var cancellableSet = Set<AnyCancellable>()
    private let container: DiContainer
    
    var trackTitle: String {
        
        switch stateMachine.state{
        case .content(let track, _):
            return (track.trackTitle  ?? String.pallete(.unknown))
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
    
    convenience init(song: TrackSong, output: SongViewModuleOutput, player: TrackPlayer, container: DiContainer){
        
        self.init(state: .content(song, .default), player: player, container: container)
        self.output = output
       
    }
    
    init(state: ViewState<TrackSong>, player: TrackPlayer, container: DiContainer){
        
        self.songService = container.serviceBuilder.getSongsServie()
        self.analytics = container.serviceBuilder.analytics
        self.container = container
        self.player = player
        self.stateMachine = ViewStateMachine(state)
        
        stateCancellable = stateMachine.$state.sink { [weak self] state in
            
            self?.objectWillChange.send()
        }
        
    }
    
    private func subscribeToPlayerChanges(){
        
        self.container.appState
            .flatMap { [weak self] state -> AnyPublisher<Bool, Never> in
                
                guard let self = self else {
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                }
                
                switch self.stateMachine.state{
                case .content(let track, _):
                    return self.container.serviceBuilder.getFavoritesService()
                        .isTrackFavorited(track)
                        .eraseToAnyPublisher()
                default:
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                }

            }
            .assign(to: &$isFavorited)
        
        self.player.$time
            .map{ [weak self] value in
                self?.objectWillChange.send()
                return value
            }
            .sinkStore(in: &cancellableSet)
    }
    
    func startScenario(){
        
        guard !isScenarioStarted else { return }
        isScenarioStarted = true
        
        subscribeToPlayerChanges()
    }
    
    func closeAction(){
        
        //Example for closing action by Coordinator
        self.output?.songViewDidClosed()
    }
    
    func playTap(){
        
        var selectedTrack: TrackSong?
        
        switch stateMachine.state{
        case .content(let track, _):
            selectedTrack = track
            if player !== container.player{
               player = container.player
            }
            player.playTrack(track)
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
    
    var leftTimeString: String {
        
        guard let duration = player.duration else {return ""}
        
        let seconds = duration - player.time
        return String(format: "-%02d:%02d", seconds/60, seconds%60) as String//"\(secs/60):\(secs%60)"
    }
    
    var timeString: String {
        
        let seconds = player.time
        return String(format: "%02d:%02d", seconds/60, seconds%60) as String//"\(secs/60):\(secs%60)"
    }
    
    func toggleFavorite() {
        
        switch self.stateMachine.state{
        case .content(let track, _):
            if isFavorited {
                container.serviceBuilder.getFavoritesService()
                    .removeTracksFromFavorites([track])
                    .sinkStore(in: &cancellableSet)
            }else{
                container.serviceBuilder.getFavoritesService()
                    .addTrackToFavorits(track)
                    .sinkStore(in: &cancellableSet)
            }
        default:
            break
        }
  
    }
    
    deinit{
        debugPrint("deinit \(Self.self)")
    }
}
