//
//  SpaceXEndpoint.swift
//  SpaceX
//
//  Created by Максим Байлюк on 24.05.2025.
//
import Foundation

enum SpaceXEndpoint {
    case rockets
    case launches(rocketID: String, page: Int, limit: Int)

    private static let baseURL = URL(string: "https://api.spacexdata.com")!

    var path: String {
        switch self {
        case .rockets: return "/v4/rockets"
        case .launches: return "/v5/launches"
        }
    }

    var method: String {
        switch self {
        case .rockets: return "GET"
        case .launches: return "POST"
        }
    }

    var queryItems: [URLQueryItem]? { nil }

    var body: Data? {
        switch self {
        case .rockets:
            return nil
        case let .launches(rocketID, page, limit):
            let parameters: [String: Any] = [
                "query": ["rocket": rocketID],
                "options": [
                    "page": page,
                    "limit": limit,
                    "sort": ["date_utc": "desc"],
                ],
            ]
            return try? JSONSerialization.data(withJSONObject: parameters)
        }
    }

    func urlRequest() throws -> URLRequest {
        var components = URLComponents(url: Self.baseURL, resolvingAgainstBaseURL: true)!
        components.path = path
        components.queryItems = queryItems

        guard let url = components.url else {
            throw NetworkError.invalidRequest
        }

        var request = URLRequest(url: url)
        request.httpMethod = method

        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        return request
    }
}
