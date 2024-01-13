//
//  SceneDelegate.swift
//  TrackPlayer
//
//  Created by Dmitry on 04.03.2023.
//

import Foundation
import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private lazy var diContainer: DiContainer = {
#if DEBUG
        DiContainer.init(buildConfiguration: .debug)
#else
        DiContainer.init(buildConfiguration: .prod)
#endif
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)
    {
        //MARK: Analytics
        if UserPreferences.isFirstAppStart == true {
            diContainer.serviceBuilder.analytics.logEvent(AppEventAnalytics.launch_first_time)
            UserPreferences.isFirstAppStart = false
        }else{
            diContainer.serviceBuilder.analytics.logEvent(AppEventAnalytics.launch_other_time)
        }
        
        let container = NavigationContainer()
        let coordinator = ApplicationCoordinator(diContainer: diContainer, container: container)
        
        container.link(coordinator: coordinator)
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = container
            self.window = window
            window.makeKeyAndVisible()
        }
        
        coordinator.start(animated: false)
    }
}

