//
//  LaunchesCoordinator.swift
//  SpaceX
//
//  Created by Максим Байлюк on 22.05.2025.
//
import SwiftData
import SwiftUI
import UIKit

final class LaunchesCoordinator {
    private let navigationController: UINavigationController
    private let rocketID: String

    init(
        navigationController: UINavigationController,
        rocketID: String
    ) {
        self.navigationController = navigationController
        self.rocketID = rocketID
    }

    @MainActor func start() {
        let launchesView = LaunchesView(rocketID: rocketID)
        let hostingController = UIHostingController(rootView: launchesView)
        navigationController.pushViewController(hostingController, animated: true)
    }
}
