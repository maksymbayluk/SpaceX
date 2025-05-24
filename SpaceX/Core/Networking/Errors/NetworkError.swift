//
//  NetworkError.swift
//  SpaceX
//
//  Created by Максим Байлюк on 24.05.2025.
//
import Foundation

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case decodingFailed
}
