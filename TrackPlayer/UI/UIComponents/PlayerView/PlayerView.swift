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
    let closeAnimation: Animation?
    
    @Binding var isClosed: Bool
    
   // @ViewBuilder
    var body: some View {
        
        VStack{
            
            HStack(alignment: .center){
                favoriteButton
                    .frame(width: 33, height: 33)
                playButton
                    .frame(width: 33, height: 33)
                titleView
                Spacer()
                closeButton.alignmentGuide(VerticalAlignment.center) { _ in 16 }
            }
            
            Slider(value: $player.volume, in: 0...100){
                Text(String.pallete(.volume))
            } minimumValueLabel: {
                let text = viewModel.timeString(player: player)
                return Text(text)
            } maximumValueLabel: {
                let textVolume = String(format: "%.f%%", player.volume)
                Text(textVolume)
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
            HStack{
                VStack(alignment: .leading){
                    Text(viewModel.songTitle)
                        .multilineTextAlignment(.leading)
                        .font(.callout)
                    Text(viewModel.artistTitle)
                        .multilineTextAlignment(.leading)
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                }
            }
        }else{
            Text(viewModel.songTitle)
                .font(.callout)
                .foregroundColor(Color.init(assetsName: .textSecondary))
                .frame(maxHeight: .infinity)
        }
    }
    
    private var closeButton: some View {
        
        Button {
            self.player.stop()
            if let closeAnimation = closeAnimation{
                withAnimation(closeAnimation){
                    self.isClosed = true
                }
            }else{
                self.isClosed = true
            }
        } label: {
            Image(sfSymbolName: .closeIcon)
        }
    }
    
    private var favoriteButton: some View {
        
        Button {
            viewModel.isFavorited.toggle()
        } label: {
            Image(sfSymbolName: viewModel.isFavorited == true ? .favoriteOn : .favoriteOff)
        }
        .font(.title)
        .foregroundColor(favoriteColor)
        .disabled(!viewModel.trackExist)
    }
    
    private var buttonColor: Color {
        
        if viewModel.trackExist == true{
            return  player.isPlaying == false ? Color.init(assetsName: .accent) : Color.init(assetsName: .iconBasic)
        }
        else{
            return Color.init(assetsName: .buttonPrimaryBackgroundDisabled)
        }
    }
    
    private var favoriteColor: Color {
        
        if viewModel.trackExist == true{
            return  viewModel.isFavorited == false ? Color.init(assetsName: .accent) : Color.init(assetsName: .iconBasic)
        }
        else{
            return Color.init(assetsName: .buttonPrimaryBackgroundDisabled)
        }
    }
}

#if DEBUG
struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(player: .init(),
                   viewModel: .init(track: nil),
                   closeAnimation: nil,
                   isClosed: .constant(false))
            .padding()
            .background(Color.init(assetsName: .backgroundCard))
    }
}
#endif
