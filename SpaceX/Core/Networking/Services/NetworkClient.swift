//
//  NetworkClient.swift
//  SpaceX
//
//  Created by Максим Байлюк on 24.05.2025.
//
import Foundation

final class NetworkClient: NetworkClientProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func performRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: request)

        guard
            let httpResponse = response as? HTTPURLResponse,
            (200 ... 299).contains(httpResponse.statusCode) else
        {
            throw NetworkError.invalidResponse
        }

        return try decoder.decode(T.self, from: data)
    }
}
