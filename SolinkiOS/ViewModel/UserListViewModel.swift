//
//  UserViewModel.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-26.
//

import Combine
import Foundation

//@MainActor --> dont need because of .receive(on: DispatchQueue.main)

class UserListViewModel: ObservableObject {
    private let photoRepository: PhotoRepository = DependencyUtil.shared
        .makePhotoRepository()
    @Published var state: StateHolder<UserListStateHolder> = .loading

    private var fetchTrigger = PassthroughSubject<(Int, Int), Never>()
    private var cancellables = Set<AnyCancellable>()

    init(pageNum: Int, pagePer: Int) {
        print("UserListViewModel init")
        //setupBindings()
        fetchData(pageNum: pageNum, pagePer: pagePer)
    }

    deinit {
        print("UserListViewModel deinit")
    }

    func fetchData(pageNum: Int, pagePer: Int) {
        self.photoRepository.fetchPhotoById(page: pageNum, perPage: pagePer)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let photoResponse):
                    self?.state = .success(
                        UserListStateHolder(
                            users: photoResponse.photos.map { it in
                                UserListItemStateHolder(
                                    id: UUID(),
                                    name: it.photographer,
                                    imageURL: it.src.small,
                                    processOnClick: { callback in callback(it) }
                                )
                            }))
                case .error(let code, let message):
                    self?.state = .error(APIError.serverError(code: code, message: message).localizedDescription)
                }
            }
            .store(in: &cancellables)
    }
}
