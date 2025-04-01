//
//  ApiResult.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-26.
//

import Foundation

enum APIError: Error {
    case serverError(code: Int, message: String?)
    
    var localizedDescription: String {
        switch self {
        case .serverError(let code, let message):
            return "Error \(code): \(message ?? "Unknown error")"
        }
    }
}

enum ApiResult<T> {
    case success(T)
    case error(Int, String?) // Code and message
}
