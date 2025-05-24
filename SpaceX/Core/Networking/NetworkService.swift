//
//  NetworkService.swift
//  SpaceX
//
//  Created by Максим Байлюк on 22.05.2025.
//
import UIKit

final class NetworkService {
    static let shared = NetworkService()
    private let session = URLSession.shared
    
    func fetchRockets(completion: @escaping (Result<[Rocket], Error>) -> Void) {
        let url = URL(string: "https://api.spacexdata.com/v4/rockets")!
        
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let rockets = try JSONDecoder().decode([Rocket].self, from: data)
                completion(.success(rockets))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

extension NetworkService {
    func fetchLaunches(rocketID: String, page: Int, perPage: Int) async throws -> [Launch] {
        let url = URL(string: "https://api.spacexdata.com/v5/launches/query")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let query: [String: Any] = [
            "query": ["rocket": rocketID],
            "options": [
                "page": page,
                "limit": perPage,
                "sort": ["date_utc": "desc"]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: query)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(LaunchesResponse.self, from: data)
        return response.docs
    }
}

private struct LaunchesResponse: Codable {
    let docs: [Launch]
}
