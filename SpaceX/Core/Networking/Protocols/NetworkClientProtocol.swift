//
//  NetworkClientProtocol.swift
//  SpaceX
//
//  Created by Максим Байлюк on 24.05.2025.
//
import Foundation

// MARK: - NetworkClientProtocol

protocol NetworkClientProtocol {
    func performRequest<T: Decodable>(
        _ request: URLRequest,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy
    ) async throws
        -> T
}

extension NetworkClientProtocol {
    func performRequest<T: Decodable>(
        _ request: URLRequest
    ) async throws -> T {
        try await performRequest(
            request,
            dateDecodingStrategy: .iso8601,
            keyDecodingStrategy: .useDefaultKeys
        )
    }
}
