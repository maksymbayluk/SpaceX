//
//  LaunchRow.swift
//  SpaceX
//
//  Created by Максим Байлюк on 24.05.2025.
//
import SwiftUI

struct LaunchRow: View {
    let launch: Launch

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                patchImage

                launchInfo

                Spacer()

                successIndicator
            }

            detailsSection
            linksSection
        }
        .padding(.vertical, 8)
    }

    private var patchImage: some View {
        Group {
            if
                let patchURLString = launch.links.patch?.small,
                let patchURL = URL(string: patchURLString)
            {
                AsyncImage(url: patchURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case let .success(image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        placeholderImage
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 50, height: 50)
            } else {
                placeholderImage
            }
        }
    }

    private var placeholderImage: some View {
        Image(systemName: "photo")
            .frame(width: 50, height: 50)
            .foregroundColor(.gray)
    }

    private var launchInfo: some View {
        VStack(alignment: .leading) {
            Text(launch.name)
                .font(.headline)

            Text(launch.date_utc.formatted(date: .abbreviated, time: .shortened))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    private var successIndicator: some View {
        Image(systemName: launch.success ?? false ? "checkmark.circle.fill" : "xmark.circle.fill")
            .foregroundColor(launch.success ?? false ? .green : .red)
    }

    private var detailsSection: some View {
        Group {
            if let details = launch.details, !details.isEmpty {
                Text(details)
                    .font(.caption)
                    .lineLimit(3)
            }
        }
    }

    private var linksSection: some View {
        Group {
            if
                let articleURLString = launch.links.article,
                let articleURL = URL(string: articleURLString)
            {
                Link("Read Article", destination: articleURL)
                    .font(.caption)
            }

            if
                let wikipediaURLString = launch.links.wikipedia,
                let wikipediaURL = URL(string: wikipediaURLString)
            {
                Link("Wikipedia", destination: wikipediaURL)
                    .font(.caption)
            }
        }
    }
}
