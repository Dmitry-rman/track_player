//
//  SongsListView.swift
//  PiratePlayer
//
//  Created by Dmitry on 04.03.2023.
//

import SwiftUI

struct SongsListView<ViewModel: SongsListViewModelProtocol>: View {
    
    @StateObject var viewModel: ViewModel
    
    private let contentBackgroundColor = Color(assetsName: .backgroundBasic)
    
    var body: some View {
        
        self.currentContent
            .onAppear(perform: {
                viewModel.startScenario()
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
        
        VStack(spacing: 16){
            searchBar
            if let songs = songs{
                if songs.count > 0 {
                    ScrollView{
                        LazyVStack(alignment: .leading, spacing: 12){
                            ForEach(songs, id: \.id){ song in
                                songListRow(song: song)
                            }
                        }
                    }
                }else{
                    Text(String.pallete(.noTracksFound))
                        .font(.subheadline)
                        .foregroundColor(Color.init(assetsName: .textSecondary))
                    Spacer()
                }
            }
            
            if let errorString = error?.localizedDescription{
                Spacer()
                Text(errorString)
                    .foregroundColor(Color(assetsName: .inputError))
            }
        }
        .padding()
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
    
    private func songListRow(song: TrackSong) -> some View{
        
        Button(action: {
            self.viewModel.selectTrack(song)
        }, label: {
            HStack{
                Image(sfSymbolName: .waveformCircle)
                VStack(alignment: .leading){
                    Text(song.trackTitle ?? String.pallete(.unknown))
                        .font(.title3)
                        .foregroundColor(Color.init(assetsName: .textPrimary))
                    Text(song.artistTitle ?? String.pallete(.unknown))
                        .font(.subheadline)
                        .foregroundColor(Color.init(assetsName: .textSecondary))
                }
                Spacer()
                Image(sfSymbolName: .chevronRight)
            }
        })
    }
}

#if DEBUG
struct SongsListView_Previews: PreviewProvider {

    static var previews: some View {
        Group{
            SongsListView(viewModel: SongsListViewModel.init(state: .content(nil, .default), container: .preview, searchResultLimit: 25))
         //   SongsListView(viewModel: SongsListViewModel.init(state: .loading, container: .preview))
        }
    }
}
#endif
