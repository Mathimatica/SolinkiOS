//
//  UserViewModel.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-26.
//

import Foundation

@MainActor
class UserViewModel : ObservableObject{
    private let userRepository: UserRepository
    @Published var state: StateHolder<UserStateHolder> = .loading
    private var fetchDataTask: Task<Void, Never>? // Store the Task

    init(userRepository: UserRepository, userId: Int, pageNum: Int, pagePer: Int) {
        self.userRepository = userRepository
        fetchData(userId:userId, pageNum: pageNum, pagePer: pagePer)
    }

    func fetchData(userId: Int, pageNum: Int, pagePer: Int) {
        fetchDataTask = Task { // Store the Task
            self.state = .loading
            let userResult = await userRepository.fetchUserById(userId: userId)
            if Task.isCancelled {
                return // Exit if cancelled
            }
            switch userResult {
            case .success(let userResponse):
                self.state = .success(UserStateHolder(userName: userResponse.name, photoUrl: ""))
            case .error(let code, let message):
                self.state = .error("User Error \(code): \(message ?? "")")
            }
        }
    }

    deinit {
        fetchDataTask?.cancel() // Cancel the Task on deinit
    }
}
