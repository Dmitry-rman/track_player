//
//  BaseTrackListViewModel.swift
//  TrackPlayer
//
//  Created by Dmitry on 13.03.2023.
//

import Combine

class BaseTrackListViewModel: IBaseTrackListViewModel {
    @Published var tracks: [TrackSong] = []
    @Published var isPlayerPlayed: Bool = false
    @Published var playingTrack: TrackSong?
    
    let container: DiContainer
    let stateMachine: ViewStateMachine<[TrackSong]?>
    
    internal var isScenarioStarted: Bool = false
    internal var cancellableSet = Set<AnyCancellable>()
    
    internal let songService: SongService
    internal let analytics: Analytics
    
    @Published private var player: TrackPlayer
    
    init(state: ViewState<[TrackSong]?>, container: DiContainer) {
        self.container = container
        self.songService = container.serviceBuilder.getSongsServie()
        self.analytics = container.serviceBuilder.analytics
        self.stateMachine = .init(state)
        
        self.player = container.player
        
        stateMachine.$state.sink { [weak self] state in
            guard let self = self else {return}
            debugPrint(state)
            switch state{
            case .content(let list, _):
                self.tracks = list ?? []
            default:
                break
            }
            self.objectWillChange.send()
        }
        .store(in: &cancellableSet)
        
        player.$isPlaying
            .assign(to: &$isPlayerPlayed)
        
        player.$playingTrack
            .assign(to: &$playingTrack)
        
    }
    
    func onFirstAppear() {
        do{
            try self.container.serviceBuilder.getAudioEngine().initAudioSession()
        }catch{
            debugPrint(error)
        }
    }
    
    func selectTrack(_ track: TrackSong) {
        //send analytics
        if let trackName = track.trackTitle {
            self.analytics.logEvent(AppEventAnalytics.select_track,
                                    properties: ["name" : trackName])
        }else{
            self.analytics.logEvent(AppEventAnalytics.select_track)
        }
    }
    
    func errorMessage(error: Error?) -> String? {
        if let error = error as? AppError{
            return "API Error: \(error.localizedDescription)"
        }else{
            return error?.localizedDescription
        }
    }
    
    func stopPlayer(){
        player.pause()
    }
    
    func playTrack(_ track: TrackSong) {
        player.playTrack(track)
    }
}
