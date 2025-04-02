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
        setupBindings()
        fetchData(pageNum: pageNum, pagePer: pagePer)
    }

    deinit {
        print("UserListViewModel deinit")
    }

    func fetchData(pageNum: Int, pagePer: Int) {
        fetchTrigger.send((pageNum, pagePer))
    }

    private func setupBindings() {
        fetchTrigger
            .flatMap { [weak self] (pageNum, pagePer) in
                Future<PhotoResponse, Error> { [weak self] promise in
                    guard let self else { return }
                    let task = Task { @MainActor in
                        let result = await self.photoRepository.fetchPhotoById(
                            page: pageNum, perPage: pagePer)
                        if Task.isCancelled {
                            promise(.failure(CancellationError()))
                            return
                        }
                        switch result {
                        case .success(let photoResponse):
                            promise(.success(photoResponse))
                        case .error(let code, let message):
                            promise(
                                .failure(
                                    APIError.serverError(
                                        code: code, message: message)))
                        }
                    }
                    task.store(in: &self.cancellables)
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] photoResponse in
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
            }
            .store(in: &cancellables)
    }
}

extension Task {
    func store(in set: inout Set<AnyCancellable>) {
        set.insert(
            AnyCancellable {
                self.cancel()
            })
    }
}
