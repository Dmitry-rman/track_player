//
//  CloseToolbar.swift
//  WBStat
//
//  Created by Dmitry on 14.04.2023.
//

import SwiftUI

extension CloseToolbar{
    private enum Constants {
        static let buttonHieght = 44.0
    }
}

struct CloseToolbar: View{
    let title: String?
    let buttonType: CloseButtonType
    
    enum CloseButtonType{
        case close(plain: Bool)
        case done
        case closeIcon
        case cancel
    }
    
    private let leadingAlignment: Bool
    let onDismiss: ()->()
    
    init(
        title: String? = nil,
        buttonType: CloseButtonType = .close(plain: true),
        leadingAlignment: Bool = false,
        onDismiss: @escaping ()->())
    {
        
        self.title = title
        self.onDismiss = onDismiss
        self.leadingAlignment = leadingAlignment
        self.buttonType = buttonType
    }
    
    var body: some View{
        HStack{
            Group{
                if leadingAlignment {
                    buttonView
                }else{
                    Spacer()
                }
            }
            .frame(width: self.buttonWidth)
            
            Spacer()
            
            Text(title ?? "")
                .font(.title.weight(.semibold))
            Spacer()
            Group{
                if !leadingAlignment{
                    buttonView
                }else{
                    Spacer()
                }
            }
            .frame(width: self.buttonWidth)
        }
        #if os(xrOS)
        .padding(.horizontal, .medium)
        #else
        .padding(.horizontal, .xxSmall)
        #endif
        .frame(height: Constants.buttonHieght)
    }
    
    private var buttonWidth: CGFloat{
        switch buttonType{
        case .closeIcon:
            return 44.0
        default:
            return 88.0
        }
    }
    
    @ViewBuilder
    private var buttonView: some View{
        switch buttonType{
        case .close(let plain):
            if plain{
                Button("Close") {
                    onDismiss()
                }
            }else{
                Button("Close") {
                    onDismiss()
                }
                .buttonStyle(AppPrimaryButtonStyle(height: Constants.buttonHieght))
            }
           
        case .done:
            Button("Done") {
                onDismiss()
            }
            .buttonStyle(AppPrimaryButtonStyle(height: Constants.buttonHieght))
        case .cancel:
            Button("Cancel") {
                onDismiss()
            }
        case .closeIcon:
            Button{
                onDismiss()
            } label: {
                Image(sfSymbolName: .closeIcon)
                    .font(.system(size: 17, weight: .bold))
            }
        }
        
    }
}

#if DEBUG
struct CloseToolbar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 0){
                CloseToolbar(title: "Hello world",
                             buttonType: .closeIcon,
                             leadingAlignment: true,
                             onDismiss: {})
                Divider()
                Spacer()
            }
        }
    }
}
#endif
