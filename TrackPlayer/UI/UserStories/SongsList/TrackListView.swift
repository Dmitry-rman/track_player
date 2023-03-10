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
    
    private let contentBackgroundColor = Color(assetsName: .backgroundBasic)
    private let playerPopupAnimation: Animation = .easeInOut(duration: 0.2)
    
    var body: some View {
        
        self.currentContent
            .onAppear(perform: {
                viewModel.startScenario()
                viewModel.onShowPlayer = { isShowed in
                    withAnimation(playerPopupAnimation){
                        self.isPlayerClosed = !isShowed
                    }
                }
            })
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
                    LoadingIndicator()
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
                .padding(.horizontal)
            
            if let songs = songs{
                if songs.count > 0 {
                    ScrollView{
                        LazyVStack(alignment: .leading, spacing: 12){
                            ForEach(songs, id: \.id){ song in
                                trackListRow(track: song)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                    
                }else{
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
                    PlayerView(player: viewModel.player ?? .init(),
                               viewModel: .init(track: viewModel.playingTrack), closeAnimation: playerPopupAnimation,
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
    private var searchBar: some View{
        
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
    private var searchLoadingView: some View{
        
        let size = 33.0
        
        if viewModel.searching == true {
            LoadingIndicator(size: .init(width: size,
                                         height: size))
        }else {
            Image(sfSymbolName: .search)
                .frame(width: size,
                       height: size)
        }
    }
    
    private func trackListRow(track: TrackSong) -> some View{
        
        let isPlaying = viewModel.isPlayerPlayed && (track == viewModel.playingTrack)
        
        return Button(action: {
            self.queryIsFocused = false
            self.viewModel.selectTrack(track)
        }, label: {
            
            HStack{
                Button {
                    if isPlaying == true {
                        viewModel.stopPlayer()
                    }else{
                        self.queryIsFocused = false
                        viewModel.trackDidPlayed(track: track)
                    }
                } label: {
                    Image(sfSymbolName: isPlaying ? .pauseCircleFill : .playCircle)
                        .font(.system(size: 23))
                        .imageScale( isPlaying ? .large : .medium)
                }
                .frame(width: 33)
               
                VStack(alignment: .leading){
                    Text(track.trackTitle ?? String.pallete(.unknown))
                        .multilineTextAlignment(.leading)
                        .font(isPlaying ? .title3.bold() : .title3)
                        .foregroundColor(Color.init(assetsName: .textPrimary))
                    Text(track.artistTitle ?? String.pallete(.unknown))
                        .multilineTextAlignment(.leading)
                        .font(isPlaying ? .subheadline.bold() : .subheadline)
                        .foregroundColor(Color.init(assetsName: .textSecondary))
                }
                Spacer()
                Image(sfSymbolName: .chevronRight)
                    .font(isPlaying ? .title2.bold() : .title2)
            }
        })
    }
}

#if DEBUG
struct SongsListView_Previews: PreviewProvider {

    static var previews: some View {
        Group{
            TrackListView(viewModel: TrackListViewModel.init(state: .content(nil, .default), container: .preview, searchResultLimit: 25))
         //   SongsListView(viewModel: SongsListViewModel.init(state: .loading, container: .preview))
        }
    }
}
#endif
