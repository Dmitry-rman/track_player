//
//  PlayerView.swift
//  PiratePlayer
//
//  Created by Dmitry on 05.03.2023.
//

import SwiftUI

struct PlayerView<ViewModel: PlayerViewModel>: View {
    
    ///Here we should use ObservedObject instead StateObject to update PlayerView from outside
    @ObservedObject var player: AVSoundPlayer
    @ObservedObject var viewModel: ViewModel
    
    @Binding var isClosed: Bool
    
    var body: some View {
        
        HStack(alignment: .top){
            Button(action: {
                if player.isPlaying == true {
                    player.pause()
                }else{
                    player.playSound(url: viewModel.track?.trackUrl)
                }
            }) {
                Image(sfSymbolName:  player.isPlaying == true ? .pauseCircleFill : .playCircle)
                    .resizable()
                    .foregroundColor(buttonColor)
            }
            .disabled(!viewModel.trackExist)
            .frame(width: 44, height: 44)
            
            if viewModel.trackExist {
                VStack(alignment: .leading){
                    Text(viewModel.songTitle)
                        .font(.callout)
                    Text(viewModel.artistTitle)
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                }
            }else{
                Text(viewModel.songTitle)
                    .font(.callout)
                    .foregroundColor(Color.init(assetsName: .textSecondary))
                    .frame(maxHeight: .infinity)
            }
            Spacer()
            
            Button {
                self.player.stop()
                self.isClosed = true
            } label: {
                Image(sfSymbolName: .closeIcon)
            }
        }
        .frame(height: 44)
    }
    
    private var buttonColor: Color{
        
        if viewModel.trackExist == true{
            return  player.isPlaying == false ? Color.init(assetsName: .accent) : Color.init(assetsName: .iconBasic)
        }
        else{
            return Color.init(assetsName: .buttonPrimaryBackgroundDisabled)
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(player: .init(), viewModel: .init(track: nil),
                   isClosed: .constant(false))
        .padding()
    }
}
