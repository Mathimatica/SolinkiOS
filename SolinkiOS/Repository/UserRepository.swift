//
//  UserRepository.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-26.
//

import Foundation

protocol UserRepository {
    func fetchUserById(userId: Int) async -> ApiResult<UserResponse>
}

class MockUserRepository: UserRepository {
    func fetchUserById(userId: Int) async -> ApiResult<UserResponse> {
        return .success(
            UserResponse(
                id: 0, name: "Josh", username: "JoshUser", email: "Email"))
    }
}

//class UserRepositoryImpl: UserRepository {
//
//    func fetchUserById(userId: Int) async -> ApiResult<UserResponse> {
//        do {
//            let response: UserResponse = try await UserService.shared.request("users/\(userId)", method: .get)
//            return .success(response)
//        } catch {
//            if let afError = error as? AFError {
//                let statusCode = afError.responseCode ?? -1
//                let errorMessage = afError.errorDescription ?? "Unknown error"
//                return .error(statusCode, errorMessage)
//            } else {
//                return .error(-1, error.localizedDescription)
//            }
//        }
//    }
//}
