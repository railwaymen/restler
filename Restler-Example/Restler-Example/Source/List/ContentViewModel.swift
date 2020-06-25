//
//  ContentViewModel.swift
//  Restler-Example
//
//  Created by Bartłomiej Świerad on 21/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import SwiftUI
import Combine
import Restler

class ContentViewModel: ObservableObject {
    private let restler = Restler(baseURL: URL(string: "https://jsonplaceholder.typicode.com")!)
    
    private var subscriptions = [AnyCancellable]()
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
        return PostViewModel(post: post)
    }
    
    // MARK: - Private
    private func fetchData() -> AnyPublisher<[BlogPost], Error>? {
        self.restler
            .get(Endpoint.posts)
            .publisher()?
            .receive(on: DispatchQueue.main)
            .tryMap(\.data)
            .decode(type: [BlogPost].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
