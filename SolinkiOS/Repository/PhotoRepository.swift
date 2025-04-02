//
//  PhotoRepository.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-26.
//

import Combine
import Foundation

protocol PhotoRepository {
    func fetchPhotoById(page: Int, perPage: Int) -> AnyPublisher<
        ApiResult<PhotoResponse>, Never
    >
}

class MockPhotoRepository: PhotoRepository {
    func fetchPhotoById(page: Int, perPage: Int) -> AnyPublisher<
        ApiResult<PhotoResponse>, Never
    > {
        Just(ApiResult.success(PhotoResponse(photos: [])))
            .eraseToAnyPublisher()
    }
}

class PhotoRepositoryImpl: PhotoRepository {

    func fetchPhotoById(page: Int, perPage: Int) -> AnyPublisher<
        ApiResult<PhotoResponse>, Never
    > {
        
        let timeoutSeconds: TimeInterval = 10 // Configurable timeout
        let maxRetries: Int = 2 // Configurable retry count
        
        let queryParams: [String: Any] = [
            "page": page,
            "per_page": perPage,
        ]
        let headers: [String: String] = [
            "Authorization":
                "FyawVqgusyrCd8HvbeY1OpuPTp4fn0tcvaPvirjDMN1ua3uHDLM95Ikg"
        ]

        return PhotoService.shared.request(
            "v1/curated",
            method: "GET",
            queryParams: queryParams,
            headers: headers
        )
        .timeout(.seconds(timeoutSeconds),
                 scheduler: DispatchQueue.main,
                 customError: { URLError(.timedOut) }) // Custom timeout error
                .retry(maxRetries)
                .map { ApiResult.success($0) }
        .catch { error -> Just<ApiResult<PhotoResponse>> in
            switch error {
            case NetworkError.httpError(let code, let message):
                return Just(.error(code, message))
            case NetworkError.invalidURL:
                return Just(.error(-1, "Invalid URL"))
            case NetworkError.invalidResponse:
                return Just(.error(-1, "Invalid Response"))
            case NetworkError.dataDecodingError:
                return Just(.error(-1, "Data Decoding Error"))
            case NetworkError.jsonEncodingError:
                return Just(.error(-1, "JSON Encoding Error"))
            default:
                return Just(.error(-1, error.localizedDescription))
            }
        }
        .eraseToAnyPublisher()
    }
}
