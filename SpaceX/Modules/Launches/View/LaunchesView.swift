//
//  LaunchesView.swift
//  SpaceX
//
//  Created by Максим Байлюк on 22.05.2025.
//
import SwiftUI

struct LaunchesView: View {
    @StateObject private var viewModel: LaunchesViewModel
    @State private var errorMessage: String?

    init(rocketID: String) {
        let vm = LaunchesViewModel(
            rocketID: rocketID,
            storageService: AppDependencies.shared.launchStorageService
        )
        _viewModel = StateObject(wrappedValue: vm)
    }

    var body: some View {
        List {
            launchesList
            loadingIndicator
        }
        .navigationTitle("Launches")
        .task(fetchLaunches)
        .onAppear {
            viewModel.onError = { error in
                errorMessage = error.localizedDescription
            }
        }
        .alert("Error", isPresented: .constant(errorMessage != nil)) {
            Button("OK") { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }

    private var launchesList: some View {
        ForEach(viewModel.launches) { launch in
            LaunchRow(launch: launch)
                .onAppear {
                    Task {
                        await viewModel.loadMoreLaunchesIfNeeded(currentItem: launch)
                    }
                }
        }
    }

    private var loadingIndicator: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }

    @Sendable
    private func fetchLaunches() async {
        await viewModel.fetchLaunches()
    }
}
