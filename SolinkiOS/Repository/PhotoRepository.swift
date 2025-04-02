//
//  PhotoRepository.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-26.
//

import Foundation

protocol PhotoRepository {
    func fetchPhotoById(page: Int, perPage: Int) async -> ApiResult<
        PhotoResponse
    >
}

class MockPhotoRepository: PhotoRepository {
    func fetchPhotoById(page: Int, perPage: Int) async -> ApiResult<
        PhotoResponse
    > {
        return .success(PhotoResponse(photos: []))
    }
}

class PhotoRepositoryImpl: PhotoRepository {
    func fetchPhotoById(page: Int, perPage: Int) async -> ApiResult<
        PhotoResponse
    > {
        do {
            let queryParams: [String: Any] = [
                "page": page,
                "per_page": perPage,
            ]
            let headers: [String: String] = [
                "Authorization":
                    "FyawVqgusyrCd8HvbeY1OpuPTp4fn0tcvaPvirjDMN1ua3uHDLM95Ikg"  // Replace with your actual API key
            ]
            let photoResponse: PhotoResponse =
                try await PhotoService.shared.request(
                    "v1/curated",
                    method: "GET",
                    queryParams: queryParams,
                    headers: headers
                )
            return .success(photoResponse)
        } catch let networkError as NetworkError {
            // Handle Network errors
            switch networkError {
            case .httpError(let code, let message):
                return .error(code, message)
            case .invalidURL:
                return .error(-1, "Unvalid URL")
            case .invalidResponse:
                return .error(-1, "Invalid Response")
            case .dataDecodingError(_):
                return .error(-1, "Data Decoding Error")
            case .jsonEncodingError(_):
                return .error(-1, "JSon Encoding Error")
            }
        } catch {
            // Handle other errors
            return .error(-1, error.localizedDescription)
        }
    }
}
