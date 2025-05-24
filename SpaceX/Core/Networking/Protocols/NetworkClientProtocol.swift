//
//  NetworkClientProtocol.swift
//  SpaceX
//
//  Created by Максим Байлюк on 24.05.2025.
//
import Foundation

protocol NetworkClientProtocol {
    func performRequest<T: Decodable>(_ request: URLRequest) async throws -> T
}
