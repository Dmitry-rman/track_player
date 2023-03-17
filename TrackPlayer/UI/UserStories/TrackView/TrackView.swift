//
//  SongView.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import SwiftUI
import Combine

struct TrackView<ViewModel: TrackViewModelProtocol>: View {
    
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 8){
            
            HStack(alignment: .center){
                Spacer()
                    .frame(width: 33)
                Spacer()
                Text(viewModel.trackTitle)
                    .multilineTextAlignment(.center)
                    .font(.title)
                Spacer()
                Button(action: viewModel.closeAction) {
                    Image(sfSymbolName: .closeIcon)
                        .font(.title2)
                        .padding(.all, 4)
                        .frame(width: 33)
                }
                .padding(.all, 8)
            }
            
            Spacer()
            songImage
                .aspectRatio(1.0, contentMode: .fit)

            Text(viewModel.artistTitle)
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .foregroundColor(Color.init(assetsName: .textSecondary))
                .padding(.top, 20)
            Spacer()
            favoriteButton
            Spacer()
            playPanel
            
        }
        .padding()
        .background(Color(assetsName: .backgroundPrimary))
        .navigationBarHidden(true)
        .onAppear(){
            viewModel.startScenario()
        }
    }
    
    private var songImage: some View {
        
        AsyncImage(url: viewModel.imageUrl){ phase in
            if let image = phase.image {
                image // Displays the loaded image.
                    .resizable()
            } else if phase.error != nil {
                VStack{
                    Spacer()
                    Text(String.pallete(.imageLoadingError))
                        .foregroundColor(Color.init(assetsName: .inputError))
                    Spacer()
                }
            } else {
                VStack{
                    Spacer()
                    LoadingIndicator()
                    Spacer()
                }
            }
        }
    }
    
    private var favoriteButton: some View {
        
        Button {
            viewModel.toggleFavorite()
        } label: {
            Image(sfSymbolName: viewModel.isFavorited == true ? .favoriteOn : .favoriteOff)
        }
        .font(.title)
        .foregroundColor(favoriteColor)
    }
    
    private var favoriteColor: Color {
        
        return  viewModel.isFavorited == false ? Color.init(assetsName: .accent) : Color.init(assetsName: .iconBasic)
    
    }
    
    private var playPanel: some View{
        
        HStack{
                timeView(title: viewModel.timeString,
                         subtitle: String.pallete(.currentTime))
                Spacer()
                Button(action: {
                    if viewModel.player.isPlaying == true {
                        viewModel.player.pause()
                    }else{
                        viewModel.playTap()
                    }
                }) {
                    Image(sfSymbolName: viewModel.player.isPlaying == true ? .pauseCircleFill : .playCircle)
                        .resizable()
                        .foregroundColor(viewModel.player.isPlaying == false ? Color.init(assetsName: .accent) : Color.init(assetsName: .iconBasic))
                }
                .frame(width: 44, height: 44)
                Spacer()
                timeView(title: viewModel.leftTimeString,
                         subtitle: String.pallete(.leftTime) )
        }
    }
    
    private func timeView(title: String, subtitle: String) -> some View{
      
        VStack{
            Text(title)
                .font(.headline)
                .foregroundColor(Color.init(assetsName: .textPrimary))
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(Color.init(assetsName: .textSecondary))
        }
        .frame(width: 120)
    }
}
    
    

#if DEBUG
struct SongView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView(viewModel: TrackViewModel.init(state: .content((TrackSong.mocked), .default), player: .preview,
                                                 container: DiContainer.preview))
    }
}
#endif
