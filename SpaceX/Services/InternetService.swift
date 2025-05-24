//
//  InternetService.swift
//  SpaceX
//
//  Created by Максим Байлюк on 24.05.2025.
//
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

    private init() {
        monitor.start(queue: queue)
    }

    func isConnectedToInternet() -> Bool {
        return monitor.currentPath.status == .satisfied
    }

    func monitorConnectionStatus(_ callback: @escaping (Bool) -> Void) {
        monitor.pathUpdateHandler = { path in
            callback(path.status == .satisfied)
        }
    }
}
