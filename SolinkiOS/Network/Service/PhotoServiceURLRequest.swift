//
//  PhotoServiceURLRequest.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-04-01.
//

import Foundation

class PhotoServiceURLRequest {
    static let shared = PhotoServiceURLRequest()
    private let baseURL = "https://api.pexels.com/"
    private let session: URLSession

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        session = URLSession(configuration: configuration)
    }

    func request<T: Decodable>(
        _ endpoint: String,
        method: String = "GET",
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil
    ) async throws -> T {
        var urlComponents = URLComponents(string: "\(baseURL)\(endpoint)")

        // Append query parameters for GET requests
        if method == "GET", let parameters = parameters {
            urlComponents?.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }

        guard let url = urlComponents?.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method

        // Add headers
        headers?.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }

        // Set request body for non-GET requests
        //for body
        //        if let parameters = parameters {
        //            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        //            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //        }

        return try await withCheckedThrowingContinuation { continuation in
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                    let data = data
                else {
                    continuation.resume(throwing: NetworkError.invalidResponse)
                    return
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    let errorString =
                        String(data: data, encoding: .utf8) ?? "Unknown error"
                    continuation.resume(
                        throwing: NetworkError.httpError(
                            httpResponse.statusCode, errorString))
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(
                        T.self, from: data)
                    continuation.resume(returning: decodedResponse)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
            task.resume()
        }
    }
}
