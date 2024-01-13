//
//  AboutView.swift
//  TrackPlayer
//
//  Created by Dmitry on 13.03.2023.
//

import SwiftUI

struct AboutView: View {
    private weak var output: AboutViewModuleOutput?
    private let title: String?
    
    init(output: AboutViewModuleOutput? = nil, title: String?) {
        self.output = output
        self.title = title
    }
    
    private var versionString: String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return "v. \(appVersion ?? String.pallete(.unknown))"
    }
    
    var body: some View {
        VStack(spacing: .medium) {
            topPanelView
            
            Group {
                VStack {
                    Spacer()
                    Text(String.pallete(.appDescription))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.init(assetsName: .textPrimary))
                        .font(.system(.caption))
                        .layoutPriority(2)
                    Spacer()
                }
                
                Text(String.pallete(.songsListScreenTitle))
                    .font(.title)
                    .foregroundColor(Color.init(assetsName: .textPrimary))
                
                Text(self.versionString)
                    .font(.title3)
                    .foregroundColor(Color.init(assetsName: .textSecondary))
                
                Spacer()
            }
            .padding()
        }
        .background(Color(assetsName: .backgroundPrimary))
    }
    
    private var topPanelView: some View {
        CloseToolbar(title: title,
                     buttonType: .closeIcon,
                     leadingAlignment: true) {
            output?.aboutDidClosed()
        }
        .padding(.all, .xSmall)
    }
}

#if DEBUG
struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView(title: "About title example")
            .environment(\.colorScheme, .dark)
    }
}
#endif
