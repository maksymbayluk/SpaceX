//
//  RocketsViewModelsTests.swift
//  SpaceXTests
//
//  Created by Максим Байлюк on 25.05.2025.
//

@testable import SpaceX
import XCTest

final class RocketsViewModelTests: XCTestCase {

    // Моки сервісів
    final class MockStorageService: RocketStorageServiceProtocol {
        var rocketsToReturn: [Rocket] = []
        var savedRockets: [Rocket]?

        func loadRockets() async throws -> [Rocket] {
            return rocketsToReturn
        }

        func save(rockets: [Rocket]) async throws {
            savedRockets = rockets
        }
    }

    final class MockNetworkService: RocketNetworkServiceProtocol {
        var rocketsToReturn: [Rocket] = []

        func fetchRockets() async throws -> [Rocket] {
            return rocketsToReturn
        }
    }

    func testFetchRockets_loadsDataSuccessfully() async throws {
        let storedRockets = [
            Rocket(
                id: "1",
                name: "Stored Rocket",
                first_flight: nil,
                success_rate_pct: nil,
                height: nil,
                diameter: nil,
                mass: nil
            ),
        ]
        let remoteRockets = [
            Rocket(
                id: "2",
                name: "Remote Rocket",
                first_flight: nil,
                success_rate_pct: nil,
                height: nil,
                diameter: nil,
                mass: nil
            ),
        ]

        let storageMock = MockStorageService()
        storageMock.rocketsToReturn = storedRockets

        let networkMock = MockNetworkService()
        networkMock.rocketsToReturn = remoteRockets

        let viewModel = await RocketsViewModel(storageService: storageMock, networkService: networkMock)

        await viewModel.fetchRockets()

        await MainActor.run {
            XCTAssertEqual(viewModel.rockets.count, remoteRockets.count)
            XCTAssertEqual(viewModel.rockets.first?.id, "2")
        }

        XCTAssertEqual(storageMock.savedRockets?.count, remoteRockets.count)
    }
}

