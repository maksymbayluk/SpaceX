//
//  SpaceXApp.swift
//  SpaceX
//
//  Created by Максим Байлюк on 22.05.2025.
//

import FirebaseCore
import SwiftUI
import UIKit

// MARK: - SpaceXApp

@main
struct SpaceXApp: App {
    init() {
        FirebaseApp.configure()
    }

    @State private var window: UIWindow?
    @State private var appCoordinator: AppCoordinator?

    var body: some Scene {
        WindowGroup {
            EmptyView()
                .background(
                    WindowAccessor(window: $window)
                )
                .task(id: window) {
                    guard let window = window else { return }
                    startCoordinator(with: window)
                }
        }
    }

    private func startCoordinator(with window: UIWindow) {
        let navigationController = UINavigationController()
        let appCoordinator = AppCoordinator(window: window, navigationController: navigationController)
        self.appCoordinator = appCoordinator
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        appCoordinator.start()
    }
}

// MARK: - WindowAccessor

struct WindowAccessor: UIViewControllerRepresentable {
    @Binding var window: UIWindow?

    func makeUIViewController(context _: Context) -> UIViewController {
        let vc = UIViewController()
        DispatchQueue.main.async {
            self.window = vc.view.window
        }
        return vc
    }

    func updateUIViewController(_: UIViewController, context _: Context) {}
}
