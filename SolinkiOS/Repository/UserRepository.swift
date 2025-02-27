//
//  UserRepository.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-26.
//

import Foundation
import Alamofire

import Foundation

protocol UserRepository {
    func fetchUserById(userId: Int) async -> ApiResult<UserResponse>
}

class UserRepositoryImpl: UserRepository {
    private let userService: UserService

    init(userService: UserService) {
        self.userService = userService
    }

    func fetchUserById(userId: Int) async -> ApiResult<UserResponse> {
        do {
            let response: UserResponse = try await userService.request("users/\(userId)", method: .get)
            return .success(response)
        } catch {
            if let afError = error as? AFError {
                let statusCode = afError.responseCode ?? -1
                let errorMessage = afError.errorDescription ?? "Unknown error"
                return .error(statusCode, errorMessage)
            } else {
                return .error(-1, error.localizedDescription)
            }
        }
    }
}
