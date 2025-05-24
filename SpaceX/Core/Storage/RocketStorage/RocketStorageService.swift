//
//  RocketStorageService.swift
//  SpaceX
//
//  Created by Максим Байлюк on 24.05.2025.
//
import Foundation
import SwiftData

// MARK: - RocketStorageServiceProtocol

protocol RocketStorageServiceProtocol {
    func save(rockets: [Rocket]) async throws
    func loadRockets() async throws -> [Rocket]
}

// MARK: - RocketStorageService

@MainActor
final class RocketStorageService: RocketStorageServiceProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func save(rockets: [Rocket]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            do {
                let allCached = try modelContext.fetch(FetchDescriptor<CachedRocket>())
                for rocket in allCached {
                    modelContext.delete(rocket)
                }

                for rocket in rockets {
                    modelContext.insert(CachedRocket(from: rocket))
                }

                try modelContext.save()
                continuation.resume()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    func loadRockets() async throws -> [Rocket] {
        try await withCheckedThrowingContinuation { continuation in
            do {
                let descriptor = FetchDescriptor<CachedRocket>(
                    sortBy: [SortDescriptor(\.name, order: .forward)]
                )
                let result = try modelContext.fetch(descriptor).map(Rocket.init)
                continuation.resume(returning: result)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
