//
//  NetworkClient.swift
//  SpaceX
//
//  Created by Максим Байлюк on 24.05.2025.
//
import Foundation

final class NetworkClient: NetworkClientProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func performRequest<T: Decodable>(
        _ request: URLRequest,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy
    ) async throws
        -> T
    {
        let (data, response) = try await session.data(for: request)

        guard
            let httpResponse = response as? HTTPURLResponse,
            (200 ... 299).contains(httpResponse.statusCode) else
        {
            throw NetworkError.invalidResponse
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Decoding error:", error)
            throw error
        }
    }
}
