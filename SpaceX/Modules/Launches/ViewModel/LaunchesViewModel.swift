//
//  LaunchesViewModel.swift
//  SpaceX
//
//  Created by Максим Байлюк on 22.05.2025.
//
import SwiftData
import SwiftUI

@MainActor
final class LaunchesViewModel: ObservableObject {
    @Published private(set) var launches: [Launch] = []
    @Published private(set) var isLoading = false
    var onError: ((Error) -> Void)?

    private let rocketID: String
    private let storageService: LaunchStorageServiceProtocol
    private let networkService: LaunchNetworkServiceProtocol
    private let imageService: ImageService

    private var currentPage = 1
    private let limit = 10
    private var hasMorePages = true

    init(
        rocketID: String,
        storageService: LaunchStorageServiceProtocol,
        networkService: LaunchNetworkServiceProtocol = LaunchNetworkService()
    ) {
        self.rocketID = rocketID
        self.storageService = storageService
        self.networkService = networkService
        imageService = ImageService(modelContext: AppDependencies.shared.modelContext)
    }

    func fetchLaunches() async {
        guard !isLoading, hasMorePages else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            if currentPage == 1 {
                let cachedLaunches = try await storageService.loadLaunches(for: rocketID)
                if !cachedLaunches.isEmpty {
                    launches = cachedLaunches
                    // Calculate next page based on cached data
                    currentPage = Int(ceil(Double(cachedLaunches.count) / Double(limit))) + 1
                }
            }

            let newLaunches = try await networkService.fetchLaunches(
                rocketID: rocketID,
                page: currentPage,
                limit: limit
            )

            if currentPage == 1 {
                launches = newLaunches
                try await storageService.save(launches: newLaunches, for: rocketID)
            } else {
                let mergedLaunches = mergeLaunches(current: launches, new: newLaunches)
                try await storageService.save(launches: mergedLaunches, for: rocketID)
                launches = mergedLaunches
            }

            hasMorePages = !newLaunches.isEmpty
            currentPage += 1
        } catch {
            onError?(error)
        }
    }

    private func mergeLaunches(current: [Launch], new: [Launch]) -> [Launch] {
        var merged = current
        let newIds = new.map { $0.id }

        merged.removeAll { newIds.contains($0.id) }
        merged.append(contentsOf: new)

        return merged.sorted { $0.date_utc > $1.date_utc }
    }

    func loadMoreLaunchesIfNeeded(currentItem item: Launch) async {
        guard
            !isLoading,
            let index = launches.firstIndex(where: { $0.id == item.id }) else
        {
            return
        }

        let threshold = max(launches.count - 5, 0)
        if index >= threshold {
            if InternetService.shared.isConnectedToInternet() {
                await fetchLaunches()
            } else {
                await loadCachedLaunches()
            }
        }
    }

    func loadCachedLaunches() async {
        do {
            let cached = try await storageService.loadLaunches(for: rocketID)
            if !cached.isEmpty {
                launches = cached
                currentPage = Int(ceil(Double(cached.count) / Double(limit))) + 1
                hasMorePages = true
            }
        } catch {
            onError?(error)
        }
    }

    func loadPatchImage(for launch: Launch) async -> UIImage? {
        await imageService.loadImage(for: launch.id, imageURL: launch.links.patch?.small)
    }
}
