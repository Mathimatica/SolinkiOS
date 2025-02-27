//
//  UserService.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-26.
//

import Foundation
import Alamofire

class UserService {
    static let shared = UserService()
    private let baseURL = "https://jsonplaceholder.typicode.com/"
    private let session: Session

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        session = Session(configuration: configuration)
    }

    func request<T: Decodable>(_ endpoint: String, method: HTTPMethod = .get, parameters: [String: Any]? = nil) async throws -> T {
            let url = "\(baseURL)\(endpoint)"
            let data = try await session.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .serializingData()
                .value
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }
}
