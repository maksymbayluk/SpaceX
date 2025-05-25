//
//  LaunchesViewModelsTests.swift
//  SpaceXTests
//
//  Created by Максим Байлюк on 25.05.2025.
//

@testable import SpaceX
import XCTest

final class LaunchesViewModelTests: XCTestCase {

    func testFetchLaunches_noNewData_keepsCached() async throws {
        let storedLaunches = [
            Launch(id: "1", name: "Stored Launch", date_utc: Date(), success: nil, details: nil, links: .init(patch: nil, article: nil, wikipedia: nil)),
        ]
        let remoteLaunches: [Launch] = []

        let storageMock = MockLaunchStorageService()
        storageMock.launchesToReturn = storedLaunches

        let networkMock = MockLaunchNetworkService()
        networkMock.launchesToReturn = remoteLaunches

        let viewModel = await LaunchesViewModel(
            rocketID: "rocket1",
            storageService: storageMock,
            networkService: networkMock
        )
        await MainActor.run {
            XCTAssertEqual(viewModel.currentPage, 1)
        }

        await viewModel.fetchLaunches()

        await MainActor.run {
            XCTAssertEqual(viewModel.launches.count, storedLaunches.count)
            XCTAssertEqual(viewModel.launches.first?.id, "1")
        }
    }
}
