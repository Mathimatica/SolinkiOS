//
//  PhotoService.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-26.
//

import Foundation
//import Alamofire
//
//class PhotoService {
//    static let shared = PhotoService()
//    private let baseURL = "https://api.pexels.com/"
//    private let session: Session
//
//    private init() {
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = 30
//        session = Session(configuration: configuration)
//    }
//
//    func request<T: Decodable>(
//            _ endpoint: String,
//            method: HTTPMethod = .get,
//            parameters: [String: Any]? = nil,
//            headers: [String: String]? = nil
//        ) async throws -> T {
//            return try await withCheckedThrowingContinuation { continuation in
//                let url = "\(baseURL)\(endpoint)"
//                var actualHeaders: HTTPHeaders? = nil
//                if let headers = headers {
//                    actualHeaders = HTTPHeaders(headers)
//                }
//
//                session.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: actualHeaders)
//                    .validate()
//                    .responseDecodable(of: T.self) { response in
//                        switch response.result {
//                        case .success(let value):
//                            continuation.resume(returning: value)
//                        case .failure(let error):
//                            if let responseCode = response.response?.statusCode,
//                               let data = response.data,
//                               let errorString = String(data: data, encoding: .utf8) {
//                                continuation.resume(throwing: NetworkError.httpError(responseCode, errorString))
//                            } else {
//                                continuation.resume(throwing: NetworkError.unknownError(error.localizedDescription))
//                            }
//                        }
//                    }
//            }
//        }}
