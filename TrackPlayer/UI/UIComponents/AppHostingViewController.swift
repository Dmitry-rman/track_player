//
//  AppHostingViewController.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import SwiftUI

class AppHostingController<Content: View> : UIHostingController<Content> {
    
    internal var isInitialized = false
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        guard !isInitialized else { return }
        isInitialized = true
        
        setupController()
    }
    
    internal func setupController() {
        
        let appearance = navigationController?.navigationBar.standardAppearance
        appearance?.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(assetsName: .headerTitle) ?? UIColor.label,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0),
        ]
        appearance?.backgroundColor = UIColor(assetsName: .backgroundBasic)
        appearance?.shadowImage = nil
        appearance?.shadowColor = UIColor.clear

        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isOpaque = true
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor(assetsName: .iconBasic)
    }
}
