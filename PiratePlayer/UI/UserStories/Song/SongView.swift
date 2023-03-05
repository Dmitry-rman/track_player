//
//  SongView.swift
//  PiratePlayer
//
//  Created by Dmitry on 04.03.2023.
//

import SwiftUI
import Combine

struct SongView<ViewModel: SongViewModelProtocol, Player: AVSoundPlayer>: View {
    
    @StateObject var viewModel: ViewModel
    @StateObject var player: Player

    var body: some View {
        
        VStack(alignment: .center, spacing: 8){
            
            Button(String.pallete(.closeSongButtonTitle)) {
                self.viewModel.closeAction()
            }
            Spacer()
            songImage
                .aspectRatio(1.0, contentMode: .fit)
            Text(viewModel.songTitle)
                .font(.title)
                .padding(.top, 20)
            Text(viewModel.artistTitle)
                .font(.subheadline)
                .foregroundColor(Color.secondary)
            Spacer()
            playPanel
            
        }
        .padding()
    }
    
    private var songImage: some View {
        
        AsyncImage(url: viewModel.imageUrl){ phase in
            if let image = phase.image {
                image // Displays the loaded image.
                    .resizable()
            } else if phase.error != nil {
                VStack{
                    Spacer()
                    Text("Error occured on loading image..")
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
    
    private var playPanel: some View{
        
        HStack{
            Button(action: {
                if player.isPlaying == true {
                    player.pause()
                }else{
                    player.playSound(url: viewModel.songUrl, fromBegin: false)
                    viewModel.playTap(player: self.player)
                }
            }) {
                Image(sfSymbolName:  player.isPlaying == true ? .pauseCircleFill : .playCircle)
                    .resizable()
                    .foregroundColor(player.isPlaying == false ? Color.init(assetsName: .accent) : Color.init(assetsName: .iconBasic))
            }
            .frame(width: 44, height: 44)
        }
    }
}

#if DEBUG
struct SongView_Previews: PreviewProvider {
    static var previews: some View {
        SongView(viewModel: SongViewModel.init(state: .content((TrackSong.mocked), .default), container: DiContainer.preview), player: AVSoundPlayer())
    }
}
#endif
