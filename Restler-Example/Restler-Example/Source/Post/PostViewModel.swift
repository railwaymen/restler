//
//  PostViewModel.swift
//  Restler-Example
//
//  Created by Bartłomiej Świerad on 24/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation
import Combine
import RestlerCore

final class PostViewModel: ObservableObject {
    private let restler = Restler(baseURL: URL(string: "https://jsonplaceholder.typicode.com")!)
    
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
    
    func createViewModel(for comment: PostComment) -> CommentViewModel {
        return CommentViewModel(comment: comment)
    }
    
    // MARK: - Private
    private func fetchComments() {
        _ = self.restler
            .get(Endpoint.comments)
            .query(["postId": 1])
            .receive(on: .main)
            .decode([PostComment].self)
            .subscribe(
                onSuccess: { comments in
                    self.comments = comments
                },
                onFailure: { error in
                    print("Error:", error)
            })
    }
}
