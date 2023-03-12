//
//  PlayerView.swift
//  TrackPlayer
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
        
        VStack{
            
            HStack(alignment: .top){
                playButton
                    .frame(width: 44, height: 44)
                titleView
                Spacer()
                closeButton
            }
            
            Slider(value: $player.volume, in: 0...100){
                Text(String.pallete(.volume))
            } minimumValueLabel: {
                Text("0%")
            } maximumValueLabel: {
                Text("100%")
            }
            .disabled(!viewModel.trackExist)
            
        }
        .frame(height: 72)
    }
    
    private var playButton: some View{
        
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
    }
    
    @ViewBuilder
    private var titleView: some View {
        
        if viewModel.trackExist {
            VStack(alignment: .leading){
                Text(viewModel.songTitle)
                    .multilineTextAlignment(.leading)
                    .font(.callout)
                Text(viewModel.artistTitle)
                    .multilineTextAlignment(.leading)
                    .font(.subheadline)
                    .foregroundColor(Color.secondary)
            }
        }else{
            Text(viewModel.songTitle)
                .font(.callout)
                .foregroundColor(Color.init(assetsName: .textSecondary))
                .frame(maxHeight: .infinity)
        }
    }
    
    private var closeButton: some View{
        Button {
            self.player.stop()
            self.isClosed = true
        } label: {
            Image(sfSymbolName: .closeIcon)
        }
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

#if DEBUG
struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(player: .init(), viewModel: .init(track: nil), isClosed: .constant(false))
            .padding()
            .background(Color.gray).opacity(0.1)
    }
}
#endif
