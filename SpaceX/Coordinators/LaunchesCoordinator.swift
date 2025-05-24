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
    private let modelContext: ModelContext

    init(
        navigationController: UINavigationController,
        rocketID: String,
        modelContext: ModelContext
    ) {
        self.navigationController = navigationController
        self.rocketID = rocketID
        self.modelContext = modelContext
    }

    @MainActor func start() {
    }
}
