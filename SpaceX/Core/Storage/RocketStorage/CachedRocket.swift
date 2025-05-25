//
//  CachedRocket.swift
//  SpaceX
//
//  Created by Максим Байлюк on 24.05.2025.
//
import Foundation
import SwiftData

// MARK: - CachedRocket

@Model
final class CachedRocket {
    @Attribute(.unique) var id: String
    var name: String
    var firstFlight: String
    var successRate: Int
    var height: Double
    var diameter: Double
    var mass: Int

    init(
        id: String,
        name: String,
        firstFlight: String,
        successRate: Int,
        height: Double,
        diameter: Double,
        mass: Int
    ) {
        self.id = id
        self.name = name
        self.firstFlight = firstFlight
        self.successRate = successRate
        self.height = height
        self.diameter = diameter
        self.mass = mass
    }

    convenience init(from rocket: Rocket) {
        self.init(
            id: rocket.id,
            name: rocket.name,
            firstFlight: rocket.first_flight ?? "",
            successRate: rocket.success_rate_pct ?? 0,
            height: rocket.height?.meters ?? 0,
            diameter: rocket.diameter?.meters ?? 0,
            mass: rocket.mass?.kg ?? 0
        )
    }
}

extension Rocket {
    init(_ cached: CachedRocket) {
        self.init(
            id: cached.id,
            name: cached.name,
            first_flight: cached.firstFlight,
            success_rate_pct: cached.successRate,
            height: Rocket.Dimension(meters: cached.height),
            diameter: Rocket.Dimension(meters: cached.diameter),
            mass: Rocket.Mass(kg: cached.mass)
        )
    }
}
