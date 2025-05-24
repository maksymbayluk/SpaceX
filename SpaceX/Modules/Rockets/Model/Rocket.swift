//
//  Rocket.swift
//  SpaceX
//
//  Created by Максим Байлюк on 22.05.2025.
//
import UIKit

struct Rocket: Codable {
    let id: String
    let name: String
    let first_flight: String
    let success_rate_pct: Int
    let height: Dimension
    let diameter: Dimension
    let mass: Mass
    
    struct Dimension: Codable {
        let meters: Double?
    }
    
    struct Mass: Codable {
        let kg: Int?
    }
}
