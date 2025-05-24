//
//  RocketsCoordinator.swift
//  SpaceX
//
//  Created by Максим Байлюк on 22.05.2025.
//
import SwiftData
import UIKit

@MainActor
final class RocketsCoordinator {
    private let navigationController: UINavigationController
    private var launchesCoordinator: LaunchesCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = RocketsViewModel(storageService: AppDependencies.shared.rocketStorageService)
        let viewController = RocketsViewController(viewModel: viewModel)
        viewModel.onSelectRocket = { [weak self] rocketID in
            self?.showLaunches(for: rocketID)
        }
        navigationController.setViewControllers([viewController], animated: true)
    }

    func showLaunches(for rocketID: String) {
        let launchesCoordinator = LaunchesCoordinator(
            navigationController: navigationController, rocketID: rocketID
        )
        self.launchesCoordinator = launchesCoordinator
        launchesCoordinator.start()
    }
}
