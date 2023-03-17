//
//  FavoritesView.swift
//  TrackPlayer
//
//  Created by Dmitry on 13.03.2023.
//

import SwiftUI

struct FavoritesView<ViewModel: FavoritesViewModel>: View {
    
    @StateObject var viewModel: ViewModel
    
    private let playerPopupAnimation: Animation = .easeInOut(duration: 0.2)
    private let contentBackgroundColor = Color(assetsName: .backgroundPrimary)
    
    var body: some View {
        
        self.currentContent
            .onAppear(perform: {
                viewModel.startScenario()
            })
            .background(self.contentBackgroundColor)
    }
    
    @ViewBuilder
    private var currentContent: some View {
        
        switch self.viewModel.stateMachine.state {
            
        case .content( _ , let contentState):
            switch contentState{
            case .loading:
                ZStack {
                    mainContent()
                        .disabled(true)
                    LoadingIndicator()
                }
            case .error(let error):
                mainContent( error: error)
            default:
                mainContent()
            }
            
        case .loading:
            ZStack{
                contentBackgroundColor
                LoadingIndicator()
            }
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    func mainContent(error: Error? = nil) -> some View {
        
        VStack(spacing: 0){
            
            let tracks = viewModel.tracks
            
            if tracks.count > 0 {
                
                List{
                    ForEach(tracks){ track in
                        
                        let isPlaying = viewModel.isPlayerPlayed && (track == viewModel.playingTrack)
                        
                        TrackListRow(track: track,
                                     isPlaying: isPlaying) {
                            self.viewModel.selectTrack(track)
                        } playAction: {
                            if isPlaying == true {
                                viewModel.stopPlayer()
                            }else{
                                viewModel.playTrack(track)
                            }
                        }
                        .listSectionSeparator(.hidden)
                    }
                    .onDelete(perform: viewModel.removeTrack(at:))
                    .listRowBackground(Color(assetsName: .backgroundBasic))
                }
                .listStyle(.plain)
                .refreshable{
                    viewModel.reloadFavorites()
                }
            }else{
                GeometryReader { reader in
                    ScrollView{
                        Text(String.pallete(.noFavoritesFound))
                            .font(.subheadline)
                            .foregroundColor(Color.init(assetsName: .textSecondary))
                            .frame(maxWidth: .infinity, idealHeight: reader.size.height)
                            .padding(.top, 20)
                    }
                    .refreshable{
                        viewModel.reloadFavorites()
                    }
                }
            }
            
            if let errorString = viewModel.errorMessage(error: error){
                Text(errorString)
                    .foregroundColor(Color(assetsName: .inputError))
            }
        }
        .toolbar {
            EditButton()
                .disabled(viewModel.tracks.count == 0)
        }
        .onAppear {
            UIRefreshControl.appearance().tintColor = UIColor.init(assetsName: .accent)
            UIRefreshControl.appearance().backgroundColor = UIColor(assetsName: .backgroundPrimary)
            UIRefreshControl.appearance().attributedTitle = NSAttributedString(string: String.pallete(.pullToRefeshTitle), attributes: [.foregroundColor : UIColor(assetsName: .textSecondary) ?? .secondaryLabel])
        }
    }
}

#if DEBUG
struct FavoritesView_Previews: PreviewProvider {
    
    static var previews: some View {
        FavoritesView(viewModel: .init(state: .content(TrackSong.mockedSongs, .default), container: .preview))
        .environment(\.colorScheme, .dark)
    }
}
#endif
