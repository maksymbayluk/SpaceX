//
//  CachedLaunch.swift
//  SpaceX
//
//  Created by Максим Байлюк on 24.05.2025.
//
import Foundation
import SwiftData

// MARK: - CachedLaunch

@Model
final class CachedLaunch {
    @Attribute(.unique) var id: String
    var rocketID: String
    var name: String
    var date_utc: Date
    var success: Bool?
    var details: String?
    var patchURL: String?
    var articleURL: String?
    var wikipediaURL: String?

    init(
        id: String,
        rocketID: String,
        name: String,
        date_utc: Date,
        success: Bool?,
        details: String?,
        patchURL: String?,
        articleURL: String?,
        wikipediaURL: String?
    ) {
        self.id = id
        self.rocketID = rocketID
        self.name = name
        self.date_utc = date_utc
        self.success = success
        self.details = details
        self.patchURL = patchURL
        self.articleURL = articleURL
        self.wikipediaURL = wikipediaURL
    }

    convenience init(from launch: Launch, rocketID: String) {
        self.init(
            id: launch.id,
            rocketID: rocketID,
            name: launch.name,
            date_utc: launch.date_utc,
            success: launch.success,
            details: launch.details,
            patchURL: launch.links?.patch?.small,
            articleURL: launch.links?.article,
            wikipediaURL: launch.links?.wikipedia
        )
    }
}

extension Launch {
    init(_ cached: CachedLaunch) {
        self.init(
            id: cached.id,
            name: cached.name,
            date_utc: cached.date_utc,
            success: cached.success,
            details: cached.details,
            links: Launch.Links(
                patch: cached.patchURL.map { Launch.Links.Patch(small: $0) },
                article: cached.articleURL,
                wikipedia: cached.wikipediaURL
            )
        )
    }
}
