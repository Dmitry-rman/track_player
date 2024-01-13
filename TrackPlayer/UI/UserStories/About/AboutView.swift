//
//  AboutView.swift
//  TrackPlayer
//
//  Created by Dmitry on 13.03.2023.
//

import SwiftUI

struct AboutView: View {
    weak var output: AboutViewModuleOutput?
    
    private var versionString: String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return "v. \(appVersion ?? String.pallete(.unknown))"
    }
    
    var body: some View {
        VStack(spacing: 16){
            HStack{
                Spacer()
                
                Button(String.pallete(.closeButton)) {
                    output?.aboutDidClosed()
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(height: 44)
            
            Spacer()
            Text(String.pallete(.appDescription))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.init(assetsName: .textPrimary))
            Spacer()
            
            Text(String.pallete(.songsListScreenTitle))
                .font(.title)
                .foregroundColor(Color.init(assetsName: .textPrimary))
            
            Text(self.versionString)
                .font(.title3)
                .foregroundColor(Color.init(assetsName: .textSecondary))
            
            Spacer()
        }
        .padding()
        .background(Color(assetsName: .backgroundPrimary))
    }
}

#if DEBUG
struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
            .environment(\.colorScheme, .dark)
    }
}
#endif
