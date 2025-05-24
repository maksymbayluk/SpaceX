//
//  RocketNetworkServiceProtocol.swift
//  SpaceX
//
//  Created by Максим Байлюк on 24.05.2025.
//
import Foundation

protocol RocketNetworkServiceProtocol {
    func fetchRockets() async throws -> [Rocket]
}
