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
    private static let maxLimit = 20

    var path: String {
        switch self {
        case .rockets: return "/v4/rockets"
        case .launches: return "/v5/launches/query"
        }
    }

    var method: String {
        switch self {
        case .rockets: return "GET"
        case .launches: return "POST"
        }
    }

    var queryItems: [URLQueryItem]? { nil }

    private var body: Data? {
        switch self {
        case let .launches(rocketID, page, limit):
            let query: [String: Any] = [
                "query": [
                    "rocket": rocketID,
                ],
                "options": [
                    "page": page,
                    "limit": min(limit, 20),
                    "sort": [
                        "date_utc": "desc",
                    ],
                    "select": [
                        "name",
                        "date_utc",
                        "details",
                        "success",
                        "links.patch.small",
                        "links.article",
                        "links.wikipedia",
                    ],
                ],
            ]
            return try? JSONSerialization.data(withJSONObject: query)

        case .rockets:
            return nil
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
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        return request
    }
}
