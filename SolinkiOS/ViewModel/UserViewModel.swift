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
    private let photoRepository: PhotoRepository
    @Published var state: StateHolder<UserStateHolder> = .loading
    private var fetchDataTask: Task<Void, Never>? // Store the Task

    init(userRepository: UserRepository, photoRepository: PhotoRepository, userId: Int, pageNum: Int, pagePer: Int) {
        self.userRepository = userRepository
        self.photoRepository = photoRepository
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
                
                let photoResult = await photoRepository.fetchPhotoById(page: pageNum, perPage: pagePer)
                if Task.isCancelled {
                    return // Exit if cancelled
                }
                switch photoResult {
                case .success(let photoResponse):
                    self.state = .success(UserStateHolder(userName: userResponse.name, photoUrl: photoResponse.photos.randomElement()?.src.original ?? ""))
                case .error(let code, let message):
                    self.state = .error("User Error \(code): \(message ?? "")")
                }
            case .error(let code, let message):
                self.state = .error("User Error \(code): \(message ?? "")")
            }
        }
    }

    deinit {
        fetchDataTask?.cancel() // Cancel the Task on deinit
    }
}
