//
//  DependencyUtil.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-26.
//

import Foundation

enum Environment {
    case app
    case testing
}

class DependencyUtil {
    static let shared = DependencyUtil()
    private init() {} // Singleton to ensure one instance
    
    private var environment: Environment = .app // Default to app
    
    // Set environment (call this early in app or test lifecycle)
    func setEnvironment(_ env: Environment) {
        self.environment = env
    }
    
    // Factory methods for dependencies
    func makeUserRepository() -> UserRepository {
        switch environment {
        case .app:
            return UserRepositoryImpl()
        case .testing:
            return MockUserRepository()
        }
    }
    
    func makePhotoRepository() -> PhotoRepository {
        switch environment {
        case .app:
            return PhotoRepositoryImpl()
        case .testing:
            return MockPhotoRepository()
        }
    }
}
