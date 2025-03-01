//
//  UserViewModel.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-26.
//

import Foundation

@MainActor
class UserListViewModel : ObservableObject{
    private let photoRepository: PhotoRepository = DependencyUtil.shared.makePhotoRepository()
    @Published var state: StateHolder<UserListStateHolder> = .loading
    private var fetchDataTask: Task<Void, Never>? // Store the Task
    
    init(pageNum: Int, pagePer: Int) {
        fetchData(pageNum: pageNum, pagePer: pagePer)
    }

    func fetchData(pageNum: Int, pagePer: Int) {
        fetchDataTask = Task { // Store the Task
            self.state = .loading
            let photoResult = await photoRepository.fetchPhotoById(page: pageNum, perPage: pagePer)
            if fetchDataTask?.isCancelled ?? true { // Check again
                return // Exit if cancelled
            }
            switch photoResult {
            case .success(let photoResponse):
                
                self.state = .success(UserListStateHolder(users: photoResponse.photos.map {it in
                    UserListItemStateHolder(
                        id: UUID(), name: it.photographer,
                            imageURL: it.src.small,
                        processOnClick: { callback in
                            callback(it)
                        }
                        )
                }))
            case .error(let code, let message):
                self.state = .error("User Error \(code): \(message ?? "")")
            }
        }
    }

    deinit {
        fetchDataTask?.cancel() // Cancel the Task on deinit
    }
}
