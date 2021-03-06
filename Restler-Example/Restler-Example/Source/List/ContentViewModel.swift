//
//  ContentViewModel.swift
//  Restler-Example
//
//  Created by Bartłomiej Świerad on 21/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import SwiftUI
import Combine
import RestlerCore
import RestlerCombine

final class ContentViewModel: ObservableObject {
    private let restler = Restler(baseURL: URL(string: "https://jsonplaceholder.typicode.com")!)
    
    private var subscriptions: [AnyCancellable] = []
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    var posts: [BlogPost] = [] {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    // MARK: - Initialization
    init() {
        self.fetchData()?
            .catch { _ in Empty() }
            .assign(to: \.posts, on: self)
            .store(in: &subscriptions)
    }
    
    // MARK: - Internal
    func createPostViewModel(post: BlogPost) -> PostViewModel {
        PostViewModel(post: post)
    }
    
    func createDownloadsViewModel() -> DownloadsViewModel {
        DownloadsViewModel()
    }
    
    // MARK: - Private
    private func fetchData() -> AnyPublisher<[BlogPost], Error>? {
        self.restler
            .get(Endpoint.posts)
            .receive(on: .main)
            .decode([BlogPost].self)
            .publisher
            .eraseToAnyPublisher()
    }
}
