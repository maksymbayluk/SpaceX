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

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = RocketsViewModel(storageService: AppDependencies.shared.rocketStorageService)
        let viewController = RocketsViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: true)
    }
}
