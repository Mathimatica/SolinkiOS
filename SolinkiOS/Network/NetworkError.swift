//
//  NetworkError.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case httpError(Int, String)
    case dataDecodingError(Error)
    case jsonEncodingError(Error) // Added for JSONSerialization errors
}
