//
//  RocketNetworkService.swift
//  SpaceX
//
//  Created by Максим Байлюк on 24.05.2025.
//
import Foundation

final class RocketNetworkService: RocketNetworkServiceProtocol {
    private let client: NetworkClientProtocol

    init(client: NetworkClientProtocol = NetworkClient()) {
        self.client = client
    }

    func fetchRockets() async throws -> [Rocket] {
        let request = try SpaceXEndpoint.rockets.urlRequest()
        return try await client.performRequest(request)
    }
}
