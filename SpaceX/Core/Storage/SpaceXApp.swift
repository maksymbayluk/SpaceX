//
//  SpaceXApp.swift
//  SpaceX
//
//  Created by Максим Байлюк on 22.05.2025.
//

import SwiftUI
import SwiftData

@main
struct SpaceXApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State private var window: UIWindow?
    
    var body: some Scene {
        WindowGroup {
            Color.clear
                .onAppear {
                    if window == nil {
                        let window = UIWindow(frame: UIScreen.main.bounds)
                        self.window = window
                        
                        let navigationController = UINavigationController()
                        let appCoordinator = AppCoordinator(window: window, navigationController: navigationController)
                        
                        window.rootViewController = navigationController
                        window.makeKeyAndVisible()
                        
                        appCoordinator.start()
                    }
                }
        }
    }
}
