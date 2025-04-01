//
//  UserViewModel.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-26.
//

import Foundation
import Combine


//@MainActor --> dont need because of .receive(on: DispatchQueue.main)

class UserListViewModel : ObservableObject{
    private let photoRepository: PhotoRepository = DependencyUtil.shared.makePhotoRepository()
    @Published var state: StateHolder<UserListStateHolder> = .loading
    
    private var fetchTrigger = PassthroughSubject<(Int, Int), Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(pageNum: Int, pagePer: Int) {
        setupBindings()
        fetchData(pageNum: pageNum, pagePer: pagePer)
    }

    func fetchData(pageNum: Int, pagePer: Int) {
        fetchTrigger.send((pageNum, pagePer))
    }
    
    private func setupBindings() {
        fetchTrigger
            .flatMap { (pageNum, pagePer) in
                Future<PhotoResponse, Error> { promise in
                    Task {
                        let result = await self.photoRepository.fetchPhotoById(page: pageNum, perPage: pagePer)
                        switch result {
                        case .success(let photoResponse):
                            promise(.success(photoResponse))
                        case .error(let code, let message):
                            promise(.failure(APIError.serverError(code: code, message: message)))
                        }
                    }
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.state = .error(error.localizedDescription)
                }
            } receiveValue: { photoResponse in
                self.state = .success(UserListStateHolder(users: photoResponse.photos.map {it in
                    UserListItemStateHolder(
                        id: UUID(), name: it.photographer,
                            imageURL: it.src.small,
                        processOnClick: { callback in
                            callback(it)
                        }
                        )
                }))
            }
            .store(in: &cancellables)
    }
}
