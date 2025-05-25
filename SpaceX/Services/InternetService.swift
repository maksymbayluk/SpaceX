//
//  InternetService.swift
//  SpaceX
//
//  Created by Максим Байлюк on 24.05.2025.
//
import Combine
import Network

// MARK: - InternetServiceProtocol

protocol InternetServiceProtocol {
    func isConnectedToInternet() -> Bool
    func monitorConnectionStatus(_ callback: @escaping (Bool) -> Void)
}

// MARK: - InternetService

final class InternetService: InternetServiceProtocol {
    static let shared = InternetService()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "InternetMonitorQueue")

    @Published private(set) var isConnected: Bool = false

    private var continuation: CheckedContinuation<Bool, Never>?

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let status = path.status == .satisfied
            self.isConnected = status

            self.continuation?.resume(returning: status)
            self.continuation = nil
        }
        monitor.start(queue: queue)
    }

    func isConnectedToInternet() -> Bool {
        return isConnected
    }

    func monitorConnectionStatus(_ callback: @escaping (Bool) -> Void) {
        _ = $isConnected
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: callback)
    }

    func checkInternetStatus() async -> Bool {
        if monitor.currentPath.status != .requiresConnection {
            return isConnected
        }

        return await withCheckedContinuation { continuation in
            self.continuation = continuation
        }
    }
}
