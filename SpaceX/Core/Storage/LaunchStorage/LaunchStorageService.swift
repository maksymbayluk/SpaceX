//
//  LaunchStorageService.swift
//  SpaceX
//
//  Created by Максим Байлюк on 22.05.2025.
//
import Foundation
import SwiftData

// MARK: - LaunchStorageServiceProtocol

protocol LaunchStorageServiceProtocol {
    func save(launches: [Launch], for rocketID: String) async throws
    func loadLaunches(for rocketID: String) async throws -> [Launch]
}

// MARK: - LaunchStorageService

@MainActor
final class LaunchStorageService: LaunchStorageServiceProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func save(launches: [Launch], for rocketID: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            do {
                let descriptor = FetchDescriptor<CachedLaunch>(
                    predicate: #Predicate { $0.rocketID == rocketID }
                )
                let oldLaunches = try modelContext.fetch(descriptor)
                for launch in oldLaunches {
                    modelContext.delete(launch)
                }

                for launch in launches {
                    modelContext.insert(CachedLaunch(from: launch, rocketID: rocketID))
                }

                try modelContext.save()
                continuation.resume()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    func loadLaunches(for rocketID: String) async throws -> [Launch] {
        try await withCheckedThrowingContinuation { continuation in
            do {
                let descriptor = FetchDescriptor<CachedLaunch>(
                    predicate: #Predicate { $0.rocketID == rocketID },
                    sortBy: [SortDescriptor(\.date_utc, order: .reverse)]
                )
                let result = try modelContext.fetch(descriptor).map(Launch.init)
                continuation.resume(returning: result)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
