//
//  LaunchRow.swift
//  SpaceX
//
//  Created by Максим Байлюк on 24.05.2025.

import SwiftUI

// MARK: - PatchImageState

private enum PatchImageState {
    case loading
    case loaded(UIImage)
    case failed
}

// MARK: - LaunchRow

struct LaunchRow: View {
    let launch: Launch

    @State private var selectedURL: IdentifiableURL?
    @State private var imageLoader: ImageService?
    @State private var patchImageState: PatchImageState = .loading

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                patchImage
                launchInfo
                Spacer()
                successIndicator
            }

            detailsSection
            linksButtons
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .sheet(item: $selectedURL) { identifiableURL in
            SafariView(url: identifiableURL.url)
        }
        .task {
            if imageLoader == nil {
                imageLoader = ImageService(modelContext: AppDependencies.shared.modelContext)
            }
            if let loader = imageLoader {
                if let image = await loader.loadImage(for: launch.id, imageURL: launch.links.patch?.small) {
                    patchImageState = .loaded(image)
                } else {
                    patchImageState = .failed
                }
            }
        }
    }

    private var patchImage: some View {
        Group {
            switch patchImageState {
            case .loading:
                ProgressView()
                    .frame(width: 50, height: 50)

            case let .loaded(image):
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)

            case .failed:
                placeholderImage
                    .frame(width: 50, height: 50)
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
        if let details = launch.details, !details.isEmpty {
            return AnyView(
                Text(details)
                    .font(.caption)
                    .lineLimit(3)
            )
        } else {
            return AnyView(EmptyView())
        }
    }

    private var linksButtons: some View {
        HStack {
            if
                let articleURLString = launch.links.article,
                let articleURL = URL(string: articleURLString)
            {
                Button {
                    selectedURL = IdentifiableURL(url: articleURL)
                } label: {
                    Text("Read Article")
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }

            Spacer()

            if
                let wikipediaURLString = launch.links.wikipedia,
                let wikipediaURL = URL(string: wikipediaURLString)
            {
                Button {
                    selectedURL = IdentifiableURL(url: wikipediaURL)
                } label: {
                    Text("Wikipedia")
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.indigo)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
    }
}
