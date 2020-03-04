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
    private let restler = Restler(baseURL: URL(string: "https://jsonplaceholder.typicode.com")!)
    private let comment: PostComment
    private var tasks: Set<Restler.Task> = []
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    // MARK: - Initialization
    init(comment: PostComment) {
        self.comment = comment
    }
    
    // MARK: - Internal
    func create() {
        let optionalTask = self.restler.post(Endpoint.comments, content: self.comment) { result in
            switch result {
            case .success:
                print("Comment posted")
            case let .failure(error):
                print(error)
            }
        }
        guard let task = optionalTask else { return }
        self.tasks.update(with: task)
    }
    
    func update() {
        let optionalTask = self.restler.put(Endpoint.comment(1), content: self.comment) { result in
            switch result {
            case .success:
                print("Comment updated")
            case let .failure(error):
                print(error)
            }
        }
        guard let task = optionalTask else { return }
        self.tasks.update(with: task)
    }
    
    func delete() {
        let optionalTask = self.restler.delete(Endpoint.comment(self.comment.id)) { result in
            switch result {
            case .success:
                print("Comment deleted")
            case let .failure(error):
                print(error)
            }
        }
        guard let task = optionalTask else { return }
        self.tasks.update(with: task)
    }
    
    func cancelAllTasks() {
        self.tasks.forEach {
            $0.cancel()
            print("Task \($0.identifier) cancelled.")
        }
    }
}
