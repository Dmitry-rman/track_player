//
//  SongsListViewModel.swift
//  PiratePlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation
import Combine

protocol SongsListViewModelProtocol: ObservableObject{
    
    /// UI state machine
    var stateMachine: ViewStateMachine<[TrackSong]> { get }
    
    var searchQuery: String {get set}
    var searching: Bool {get set}
    
    func startScenario()
    func selectTrack(_ song: TrackSong)
}

final class SongsListViewModel: SongsListViewModelProtocol{

    @Published var searchQuery: String = ""
    @Published var searching: Bool = false
    
    private var chachedSongs: [TrackSong] = []
    private let container: DiContainer
    private(set) var stateMachine: ViewStateMachine<[TrackSong]>
    private var stateCancellable: AnyCancellable?
    private var isScenarioStarted = false
    private var cancellableSet = Set<AnyCancellable>()
    
    private let songService: SongService
    private let analytics: Analytics
    
    //Limit for API's track results
    private let searchResultLimit: Int
    
    private weak var output: SongsListViewModuleOutput?
    
    convenience init(output: SongsListViewModuleOutput,
                     container: DiContainer,
                     searchResultLimit: Int = 25){
        
        self.init(state: .empty,
                  container: container,
                  searchResultLimit: searchResultLimit)
        self.output = output
    }
    
    init(state: ViewState<[TrackSong]>,
         container: DiContainer,
         searchResultLimit: Int){
        
        self.container = container
        self.searchResultLimit = searchResultLimit
        self.songService = container.serviceBuilder.getSongsServie()
        self.analytics = container.serviceBuilder.analytics
        
        self.stateMachine = ViewStateMachine(state)
        stateCancellable = stateMachine.$state.sink { [weak self] state in
            debugPrint(state)
            switch state{
            case .content(let songs, _):
                self?.chachedSongs = songs
            default:
                break
            }
            self?.objectWillChange.send()
        }
        
        $searchQuery
            .filter{ $0.count >= 3}//3 simbols or more to search
            //.debounce(for: .seconds(1.0), scheduler: RunLoop.main)
            .throttle(for: .seconds(0.5), scheduler: RunLoop.main, latest: true)
            .removeDuplicates()
            .eraseToAnyPublisher()
            .flatMap { [weak self] query -> AnyPublisher<[TrackSong], Never> in
                
                guard let self = self else {
                    return  Empty(completeImmediately: true).eraseToAnyPublisher()
                }
                
                self.searching = true
                return self.songService.getSongs(byQuery: query, limit: self.searchResultLimit)
                    .catch({[weak self] error -> AnyPublisher<[TrackSong], Never> in
                        debugPrint(error)
                        self?.searching = false
                        self?.stateMachine.setState(.content([], .error(error)))
                        return Empty(completeImmediately: true).eraseToAnyPublisher()
                    })
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] error in
                
                guard let self = self else {return}
                
                debugPrint(error)
                if let error = error as? Error{
                    self.stateMachine.setState(.content((self.chachedSongs), .error(error)))
                }
            } receiveValue: { [weak self] songs in
                self?.stateMachine.setState(.content(songs, .default))
                self?.searching = false
            }
            .store(in: &cancellableSet)
        
    }
    
    //MARK: - SongsListViewModelProtocol
    
    func startScenario(){
        
        guard !isScenarioStarted else { return }
        isScenarioStarted = true
        
        self.analytics.logEvent(AppEventAnalytics.main_screen_visited)
        
        self.stateMachine.setState(.loading)
        
        self.songService
            .loadRecentSongs()
            .sink { [weak self] error in
                guard let self = self else {return}
                debugPrint(error)
                if let error = error as? Error{
                    self.stateMachine.setState(.content((self.chachedSongs), .error(error)))
                }
            } receiveValue: {  [weak self] songs in
                guard let self = self else {return}
                self.stateMachine.setState(.content((songs), .default))
            }
            .store(in: &cancellableSet)
    }
    
    func selectTrack(_ track: TrackSong) {
        
        //send analytics
        if let trackName = track.trackTitle {
            self.analytics.logEvent(AppEventAnalytics.select_track,
                                    properties: ["name" : trackName])
        }else{
            self.analytics.logEvent(AppEventAnalytics.select_track)
        }
        
        self.output?.didSelectSong(song: track)
    }
}
