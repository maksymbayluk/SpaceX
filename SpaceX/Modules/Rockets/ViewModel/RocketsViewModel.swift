//
//  RocketsViewModel.swift
//  SpaceX
//
//  Created by Максим Байлюк on 22.05.2025.
//
import Foundation

@MainActor
final class RocketsViewModel: ObservableObject {
    @Published private(set) var rockets: [Rocket] = []

    var onSelectRocket: ((String) -> Void)?
    var onError: ((Error) -> Void)?

    private let storageService: RocketStorageServiceProtocol
    private let networkService: RocketNetworkServiceProtocol

    init(
        storageService: RocketStorageServiceProtocol,
        networkService: RocketNetworkServiceProtocol = RocketNetworkService()
    ) {
        self.storageService = storageService
        self.networkService = networkService
    }

    func fetchRockets() async {
        do {
            let cached = try await storageService.loadRockets()
            rockets = cached

            let remote = try await networkService.fetchRockets()

            try await storageService.save(rockets: remote)

            rockets = remote
        } catch {
            onError?(error)
        }
    }
}
