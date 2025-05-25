//
//  MockLaunchNetworkService.swift
//  SpaceX
//
//  Created by Максим Байлюк on 25.05.2025.
//

import Foundation
@testable import SpaceX

final class MockLaunchNetworkService: LaunchNetworkServiceProtocol {
    var launchesToReturn: [Launch] = []

    func fetchLaunches(rocketID _: String, page _: Int, limit _: Int) async throws -> [Launch] {
        return launchesToReturn
    }
}
