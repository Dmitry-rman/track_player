//
//  SongsListView.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import SwiftUI
import Combine

struct TrackListView<ViewModel: TrackListViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    
    @State var isPlayerClosed: Bool = false
    @FocusState private var queryIsFocused: Bool
    
    private let contentBackgroundColor = Color(assetsName: .backgroundPrimary)
    private let playerPopupAnimation: Animation = .easeInOut(duration: 0.2)
    
    var body: some View {
        self.currentContent
            .onFirstAppear(){
                viewModel.onFirstAppear()
                
                viewModel.onShowPlayer = { isShowed in
                    if isShowed == true && isPlayerClosed == false{
                        return
                    }
                    
                    withAnimation(playerPopupAnimation){
                        self.isPlayerClosed = !isShowed
                    }
                }
            }
            .background(self.contentBackgroundColor)
    }
    
    @ViewBuilder
    private var currentContent: some View {
        switch self.viewModel.stateMachine.state {
            
        case .content(let songs, let contentState):
            switch contentState{
            case .loading:
                ZStack {
                    mainContent(songs: songs)
                        .disabled(true)
                    
                    AppLoadingIndicator()
                }
            case .error(let error):
                mainContent(songs: songs, error: error)
            default:
                mainContent(songs: songs)
            }
            
        case .loading:
            ZStack{
                self.contentBackgroundColor
                
                VStack{
                    LoadingIndicator()
                    
                    Text(String.pallete(.startLoading))
                        .font(.callout)
                        .foregroundColor(Color(assetsName: .accent))
                }
            }
            
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    func mainContent(songs: [TrackSong]?, error: Error? = nil) -> some View {
        VStack(spacing: 0){
            searchBar
                .padding()
            
            if let tracks = songs{
                if tracks.count > 0 {
                    ScrollView{
                        LazyVStack(alignment: .leading, spacing: 0){
                            ForEach(tracks, id: \.id){ track in
                                let isPlaying = viewModel.isPlayerPlayed && (track == viewModel.playingTrack)
                                
                                VStack(spacing: 0){
                                    TrackListRow(track: track,
                                                 isPlaying: isPlaying) {
                                        self.queryIsFocused = false
                                        self.viewModel.selectTrack(track)
                                    } playAction: {
                                        
                                        if isPlaying == true {
                                            viewModel.stopPlayer()
                                        }else{
                                            self.queryIsFocused = false
                                            viewModel.playTrack(track)
                                        }
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    
                                    if tracks.last != track {
                                        Divider()
                                            .padding(.leading, 60)
                                    }
                                }
                                .background(Color(assetsName: .backgroundBasic))
                            }
                            .listStyle(.plain)
                        }
                        .padding(.vertical)
                    }
                    
                } else {
                    Text(String.pallete(.noTracksFound))
                        .font(.subheadline)
                        .foregroundColor(Color.init(assetsName: .textSecondary))
                }
            }
            
            if let errorString = viewModel.errorMessage(error: error){
                Text(errorString)
                    .foregroundColor(Color(assetsName: .inputError))
            }
            
            if songs?.count ?? 0 == 0 {
                Spacer()
            }
            
            if isPlayerClosed == false {
                VStack(spacing: 0){
                    Divider()
                    PlayerView(viewModel: .init(diContainer: viewModel.container),
                               closeAnimation: playerPopupAnimation,
                               isClosed: $isPlayerClosed)
                    .padding()
                }
                .background(Color(assetsName: .backgroundCard))
                .transition(.move(edge: .bottom))
                .zIndex(1)
            }
        }
    }
    
    @ViewBuilder
    private var searchBar: some View {
        ZStack{
            Rectangle()
                .foregroundColor(Color.gray.opacity(0.2))
            
            HStack {
                searchLoadingView
                TextField(String.pallete(.searchTitle),
                          text: $viewModel.searchQuery,
                          prompt: Text(String.pallete(.searchPromt)))
                .focused($queryIsFocused)
                
                Button(action: viewModel.clearSearch) {
                    Image(sfSymbolName: .closeIcon)
                }
                .disabled(viewModel.searchQuery.count == 0)
                .padding()
            }
            .padding(.leading, 12)
            .foregroundColor(.accentColor)
            .cornerRadius(8)
        }
        .frame(height: 56)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8.0)
                .strokeBorder(self.viewModel.searching == true  ? Color.gray: .clear, lineWidth: 2)
        )
    }
    
    @ViewBuilder
    private var searchLoadingView: some View {
        let size = 33.0
        
        if viewModel.searching == true {
            LoadingIndicator(size: size)
        }else {
            Image(sfSymbolName: .search)
                .frame(width: size,
                       height: size)
        }
    }
    
}

#if DEBUG
struct SongsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            TrackListView(viewModel: TrackListViewModel.init(state: .content(TrackSong.mockedSongs, .default), diContainer: .preview, searchResultLimit: 25))
            //.environment(\.colorScheme, .dark)
            //   SongsListView(viewModel: SongsListViewModel.init(state: .loading, container: .preview))
        }
        .navigationTitle(String.pallete(.songsListScreenTitle))
    }
}
#endif
