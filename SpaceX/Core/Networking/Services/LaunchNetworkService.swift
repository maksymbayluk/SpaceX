//
//  LaunchNetworkService.swift
//  SpaceX
//
//  Created by Максим Байлюк on 24.05.2025.
//
import Foundation

final class LaunchNetworkService: LaunchNetworkServiceProtocol {
    private let client: NetworkClientProtocol

    init(client: NetworkClientProtocol = NetworkClient()) {
        self.client = client
    }

    func fetchLaunches(rocketID: String, page: Int, limit: Int) async throws -> [Launch] {
        let request = try SpaceXEndpoint.launches(rocketID: rocketID, page: page, limit: limit).urlRequest()
        let response: LaunchesResponse = try await client.performRequest(request)
        return response.docs
    }
}
