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

    func fetchLaunches(rocketID: String, page: Int, limit: Int = 20) async throws -> [Launch] {
        let request = try SpaceXEndpoint.launches(rocketID: rocketID, page: page, limit: limit).urlRequest()

        let iso8601withFractionalSecondsFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            return formatter
        }()

        let response: LaunchesResponse = try await client.performRequest(
            request,
            dateDecodingStrategy: .formatted(iso8601withFractionalSecondsFormatter),
            keyDecodingStrategy: .useDefaultKeys
        )
        return response.docs
    }
}
