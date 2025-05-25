//
//  AppDependencies.swift
//  SpaceX
//
//  Created by Максим Байлюк on 22.05.2025.
//
import SwiftData
import UIKit

@MainActor
final class AppDependencies {
    static let shared = AppDependencies()

    public let modelContainer: ModelContainer
    let modelContext: ModelContext

    init() {
        do {
            modelContainer = try ModelContainer(for: CachedLaunch.self, CachedRocket.self)
            modelContext = modelContainer.mainContext
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    // MARK: - Services

    var launchStorageService: LaunchStorageServiceProtocol {
        LaunchStorageService(modelContext: modelContext)
    }

    var rocketStorageService: RocketStorageServiceProtocol {
        RocketStorageService(modelContext: modelContext)
    }
}
