//
//  LaunchesResponse.swift
//  SpaceX
//
//  Created by Максим Байлюк on 24.05.2025.
//
import Foundation

struct LaunchesResponse: Decodable {
    let docs: [Launch]
}
