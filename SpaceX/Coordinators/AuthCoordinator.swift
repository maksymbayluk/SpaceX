//
//  AuthCoordinator.swift
//  SpaceX
//
//  Created by Максим Байлюк on 22.05.2025.
//
import UIKit

final class AuthCoordinator {
    private let navigationController: UINavigationController
    private var loginViewModel: LoginViewModel?
    private var rocketsCoordinator: RocketsCoordinator?
    var onFinish: (() -> Void)?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    @MainActor func start() {
        let viewModel = LoginViewModel()
        loginViewModel = viewModel

        viewModel.onAuthSuccess = { [weak self] in
            self?.onFinish?()
        }

        let loginVC = LoginViewController(viewModel: viewModel)
        navigationController.pushViewController(loginVC, animated: true)
    }

    @MainActor private func showRocketsAfterLogin() {
        let rocketsCoordinator = RocketsCoordinator(
            navigationController: navigationController
        )
        self.rocketsCoordinator = rocketsCoordinator
        rocketsCoordinator.start()
    }
}
