//
//  Launch.swift
//  SpaceX
//
//  Created by Максим Байлюк on 22.05.2025.
//
import UIKit

// MARK: - Launch

struct Launch: Codable, Identifiable {
    let id: String
    let name: String
    let date_utc: Date
    let success: Bool?
    let details: String?
    let links: Links

    struct Links: Codable {
        let patch: Patch?
        let article: String?
        let wikipedia: String?

        struct Patch: Codable {
            let small: String?
        }
    }
}

// MARK: Equatable

extension Launch: Equatable {
    static func == (lhs: Launch, rhs: Launch) -> Bool {
        lhs.id == rhs.id
    }
}
