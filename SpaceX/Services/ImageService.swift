//
//  ImageService.swift
//  SpaceX
//
//  Created by Максим Байлюк on 25.05.2025.
//
import SwiftData
import SwiftUI

@MainActor
final class ImageService {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func loadImage(for launchID: String, imageURL: String?) async -> UIImage? {
        if let cached = await getCachedImage(launchID: launchID) {
            return cached
        }

        guard let imageURL = imageURL, let url = URL(string: imageURL) else {
            return nil
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                await cacheImage(launchID: launchID, data: data)
                return image
            }
        } catch {
        }

        return nil
    }

    private func getCachedImage(launchID: String) async -> UIImage? {
        let descriptor = FetchDescriptor<CachedLaunch>(
            predicate: #Predicate { $0.id == launchID }
        )

        guard
            let cached = try? modelContext.fetch(descriptor).first,
            let imageData = cached.patchImageData else
        {
            return nil
        }
        return UIImage(data: imageData)
    }

    private func cacheImage(launchID: String, data: Data) async {
        let descriptor = FetchDescriptor<CachedLaunch>(
            predicate: #Predicate { $0.id == launchID }
        )

        if let cached = try? modelContext.fetch(descriptor).first {
            if cached.patchImageData == nil {
                cached.patchImageData = data
            }
        }
    }
}
