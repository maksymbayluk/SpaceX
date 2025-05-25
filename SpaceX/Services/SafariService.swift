//
//  SafariService.swift
//  SpaceX
//
//  Created by Максим Байлюк on 25.05.2025.
//
import SafariServices
import SwiftUI

// MARK: - SafariView

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context _: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_: SFSafariViewController, context _: Context) {}
}

// MARK: - IdentifiableURL

struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
}
