//
//  CommentViewModel.swift
//  Restler-Example
//
//  Created by Bartłomiej Świerad on 03/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import SwiftUI
import Combine
import Restler

class CommentViewModel: ObservableObject {
    private let restler = Restler(encoder: JSONEncoder(), decoder: JSONDecoder())
    private let comment: PostComment
    private var tasks: Set<Restler.Task>
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    // MARK: - Initialization
    init(comment: PostComment) {
        self.comment = comment
    }
    
    // MARK: - Internal
    func create() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/comments") else { return assertionFailure() }
        self.post(url: url)
    }
    
    func update() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/comments/1") else { return assertionFailure() }
        self.put(url: url)
    }
    
    func delete() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/comments/\(self.comment.id)") else { return assertionFailure() }
        self.delete(url: url)
    }
    
    // MARK: - Private
    private func post(url: URL) {
        _ = self.restler.post(url: url, content: self.comment) { result in
            switch result {
            case .success:
                print("Comment posted")
            case let .failure(error):
                print(error)
            }
        }
    }
    
    private func put(url: URL) {
        self.restler.put(url: url, content: self.comment) { result in
            switch result {
            case .success:
                print("Comment updated")
            case let .failure(error):
                print(error)
            }
        }
    }
    
    private func delete(url: URL) {
        self.restler.delete(url: url) { result in
            switch result {
            case .success:
                print("Comment deleted")
            case let .failure(error):
                print(error)
            }
        }
    }
}
