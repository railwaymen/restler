//
//  PostViewModel.swift
//  Restler-Example
//
//  Created by Bartłomiej Świerad on 24/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation
import Combine
import Restler

class PostViewModel: ObservableObject {
    private let restler: Restlerable = Restler()
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    let post: BlogPost
    
    var comments: [PostComment] = [] {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    // MARK: - Initialization
    init(post: BlogPost) {
        self.post = post
    }
    
    // MARK: - Internal
    func viewAppears() {
        self.fetchComments()
    }
    
    // MARK: - Private
    private func fetchComments() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/comments") else { return assertionFailure() }
        self.restler.get(url: url, query: ["postId": "\(self.post.id)"]) { (result: Result<[PostComment], Error>) in
            switch result {
            case let .success(comments):
                self.comments = comments
            case let .failure(error):
                print("Error:", error)
            }
        }
    }
}
