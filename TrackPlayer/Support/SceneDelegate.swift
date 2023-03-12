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
    
    private var diContainer: DiContainer!
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
#if DEBUG
        diContainer = DiContainer.init(buildConfiguration: .debug)
#else
        diContainer = DiContainer.init(buildConfiguration: .prod)
#endif
        //MARK: Analytics
        if UserPreferences.isFirstAppStart == true{
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
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
       // systemEventsHandler?.sceneOpenURLContexts(URLContexts)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
       // systemEventsHandler?.sceneDidBecomeActive()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // systemEventsHandler?.sceneWillResignActive()
    }
    
}

