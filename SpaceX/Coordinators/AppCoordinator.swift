//
//  AppCoordinator.swift
//  SpaceX
//
//  Created by Максим Байлюк on 22.05.2025.
//
import UIKit

final class AppCoordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController
    private var authCoordinator: AuthCoordinator?
    private var rocketsCoordinator: RocketsCoordinator?

    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }

    @MainActor func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        checkAuthenticationAndProceed()
    }

    @MainActor private func checkAuthenticationAndProceed() {
        AuthService.shared.checkAuthenticationStatus { [weak self] isAuthenticated, _ in
            DispatchQueue.main.async {
                if isAuthenticated {
                    self?.showRockets()
                } else {
                    self?.showAuth()
                }
            }
        }
    }

    @MainActor private func showAuth() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        self.authCoordinator = authCoordinator
        authCoordinator.onFinish = { [weak self] in
            self?.showRockets()
        }
        authCoordinator.start()
    }

    @MainActor private func showRockets() {
        let rocketsCoordinator = RocketsCoordinator(
            navigationController: navigationController
        )
        self.rocketsCoordinator = rocketsCoordinator
        rocketsCoordinator.start()
    }
}
