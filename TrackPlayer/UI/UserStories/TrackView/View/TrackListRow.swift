//
//  TrackListRow.swift
//  TrackPlayer
//
//  Created by Dmitry on 13.03.2023.
//

import SwiftUI

struct TrackListRow: View {
    let track: TrackSong
    let isPlaying: Bool
    let selectAction: ()->()
    let playAction: ()->()
    
    var body: some View {
        Button(action: selectAction,
                      label: {
            HStack{
                Button( action: playAction,
                        label: {
                    Image(sfSymbolName: isPlaying ? .pauseCircleFill : .playCircle)
                        .font(.system(size: 23))
                        .imageScale( isPlaying ? .large : .medium)
                })
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
        .foregroundColor(Color.init(assetsName: .accent))
    }
}

#if DEBUG
struct TrackListRow_Previews: PreviewProvider {
    static var previews: some View {
        TrackListRow(track: .mocked,
                     isPlaying: false,
                     selectAction: {},
                     playAction: {})
        .padding()
    }
}
#endif
