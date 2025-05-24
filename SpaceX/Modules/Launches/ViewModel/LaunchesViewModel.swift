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
    }

    func fetchLaunches() async {
        guard !isLoading, hasMorePages else { return }

        isLoading = true

        do {
            if currentPage == 1 {
                let cachedLaunches = try await storageService.loadLaunches(for: rocketID)
                if !cachedLaunches.isEmpty {
                    launches = cachedLaunches
                }
            }

            let newLaunches = try await networkService.fetchLaunches(
                rocketID: rocketID,
                page: currentPage,
                limit: limit
            )

            if currentPage == 1 {
                try await storageService.save(launches: newLaunches, for: rocketID)
                launches = newLaunches
            } else {
                launches.append(contentsOf: newLaunches)
            }

            hasMorePages = !newLaunches.isEmpty
            currentPage += 1
        } catch {
            onError?(error)
        }

        isLoading = false
    }

    func loadMoreLaunchesIfNeeded(currentItem: Launch) async {
        guard
            let lastItem = launches.last,
            lastItem.id == currentItem.id,
            !isLoading,
            hasMorePages else
        {
            return
        }

        await fetchLaunches()
    }
}
