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
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    var posts: [BlogPost] = [] {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    // MARK: - Initialization
    init() {
        self.fetchData()
    }
    
    // MARK: - Internal
    func createPostViewModel(post: BlogPost) -> PostViewModel {
        return PostViewModel(post: post)
    }
    
    // MARK: - Private
    private func fetchData() {
        _ = self.restler
            .get(Endpoint.posts)
            .decode([BlogPost].self)
            .onCompletion({ result in
                switch result {
                case let .success(posts):
                    self.posts = posts
                case let .failure(error):
                    print("Error:", error)
                }
            })
            .start()
    }
}
