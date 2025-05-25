//
//  LaunchesView.swift
//  SpaceX
//
//  Created by Максим Байлюк on 22.05.2025.
//
// import SwiftUI
//
// struct LaunchesView: View {
//    @StateObject private var viewModel: LaunchesViewModel
//    @State private var errorMessage: String?
//
//    init(rocketID: String) {
//        let vm = LaunchesViewModel(
//            rocketID: rocketID,
//            storageService: AppDependencies.shared.launchStorageService
//        )
//        _viewModel = StateObject(wrappedValue: vm)
//    }
//
//    var body: some View {
//        ZStack {
//            Color(UIColor.systemGroupedBackground)
//                .ignoresSafeArea()
//
//            ScrollView {
//                LazyVStack(spacing: 8) {
//                    launchesList
//
//                    loadingIndicator
//
//                    loadMoreTrigger
//                        .frame(height: 40)
//                }
//                .padding(.vertical)
//            }
//            .scrollIndicators(.hidden)
//        }
//        .navigationTitle("Launches")
//        .onAppear(perform: onAppear)
//    }
//
//    private var launchesList: some View {
//        ForEach(viewModel.launches) { launch in
//            LaunchRow(launch: launch)
//                .padding(.horizontal)
//                .onAppear {
//                    Task {
//                        await viewModel.loadMoreLaunchesIfNeeded(currentItem: launch)
//                    }
//                }
//        }
//    }
//
//    private var loadingIndicator: some View {
//        Group {
//            if viewModel.isLoading {
//                ProgressView()
//                    .frame(maxWidth: .infinity)
//            }
//        }
//    }
//
//    private var loadMoreTrigger: some View {
//        GeometryReader { geometry in
//            Color.clear.onAppear {
//                let minY = geometry.frame(in: .global).minY
//                let screenHeight = UIScreen.main.bounds.height
//                if minY < screenHeight {
//                    Task {
//                        if InternetService.shared.isConnectedToInternet() {
//                            await viewModel.fetchLaunches()
//                        } else {
//                            await viewModel.loadCachedLaunches()
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    private func onAppear() {
//        viewModel.onError = { error in
//            errorMessage = error.localizedDescription
//        }
//
//        if viewModel.launches.isEmpty {
//            Task {
//                if InternetService.shared.isConnectedToInternet() {
//                    await viewModel.fetchLaunches()
//                } else {
//                    await viewModel.loadCachedLaunches()
//                }
//            }
//        }
//    }
// }
import SwiftUI

struct LaunchesView: View {
    @StateObject private var viewModel: LaunchesViewModel

    init(rocketID: String) {
        let vm = LaunchesViewModel(
            rocketID: rocketID,
            storageService: AppDependencies.shared.launchStorageService
        )
        _viewModel = StateObject(wrappedValue: vm)
    }

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()

            if viewModel.launches.isEmpty {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    VStack {
                        Spacer()
                        Text(emptyStateMessage)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding()
                        Spacer()
                    }
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        launchesList
                        loadingIndicator
                        loadMoreTrigger.frame(height: 40)
                    }
                    .padding(.vertical)
                }
                .scrollIndicators(.hidden)
            }
        }
        .navigationTitle("Launches")
        .onAppear(perform: onAppear)
    }

    private var emptyStateMessage: String {
        if InternetService.shared.isConnectedToInternet() {
            return "No launches found for this rocket."
        } else {
            return "No internet connection.\nConnect to the internet and try again."
        }
    }

    private var launchesList: some View {
        ForEach(viewModel.launches) { launch in
            LaunchRow(launch: launch)
                .padding(.horizontal)
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
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private var loadMoreTrigger: some View {
        GeometryReader { geometry in
            Color.clear.onAppear {
                let minY = geometry.frame(in: .global).minY
                let screenHeight = UIScreen.main.bounds.height
                if minY < screenHeight {
                    Task {
                        if InternetService.shared.isConnectedToInternet() {
                            await viewModel.fetchLaunches()
                        } else {
                            await viewModel.loadCachedLaunches()
                        }
                    }
                }
            }
        }
    }

    private func onAppear() {
        if viewModel.launches.isEmpty {
            Task {
                if InternetService.shared.isConnectedToInternet() {
                    await viewModel.fetchLaunches()
                } else {
                    await viewModel.loadCachedLaunches()
                }
            }
        }
    }
}
