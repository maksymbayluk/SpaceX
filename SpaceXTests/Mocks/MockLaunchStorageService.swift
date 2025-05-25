//
//  MockLaunchStorageService.swift
//  SpaceX
//
//  Created by Максим Байлюк on 25.05.2025.
//

import Foundation
@testable import SpaceX

final class MockLaunchStorageService: LaunchStorageServiceProtocol {
    var launchesToReturn: [Launch] = []
    var savedLaunches: [Launch]? = nil

    func loadLaunches(for _: String) async throws -> [Launch] {
        return launchesToReturn
    }

    func save(launches: [Launch], for _: String) async throws {
        savedLaunches = launches
    }
}
