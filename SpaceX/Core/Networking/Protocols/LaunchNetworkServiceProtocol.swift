//
//  LaunchNetworkServiceProtocol.swift
//  SpaceX
//
//  Created by Максим Байлюк on 24.05.2025.
//
import Foundation

protocol LaunchNetworkServiceProtocol {
    func fetchLaunches(rocketID: String, page: Int, limit: Int) async throws -> [Launch]
}
