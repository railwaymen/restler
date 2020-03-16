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
    
    private var imageEncoder: ImgurImageEncoder {
        return ImgurImageEncoder(
            title: "Desktop",
            description: "Little image of my desktop",
            image: Restler.MultipartObject(
                filename: "desktop.png",
                contentType: "image/png",
                body: #imageLiteral(resourceName: "imgurImage").pngData()!))
    }
    
    // MARK: - Initialization
    init(comment: PostComment) {
        self.comment = comment
    }
    
    // MARK: - Internal
    func create() {
        let task = self.restler
            .post(Endpoint.comments)
            .body(self.comment)
            .decode(Void.self)
            .onCompletion({ result in
                switch result {
                case .success:
                    print("Comment posted")
                case let .failure(error):
                    print(error)
                }
            })
            .start()
        self.add(task: task)
    }
    
    func postMultipart() {
        guard let clientID = Bundle.main.infoDictionary?["IMGUR_CLIENT_ID"] as? String else { return }
        let restler = Restler(baseURL: URL(string: "https://api.imgur.com/3")!)
        let task = restler
            .post(ImgurEndpoint.upload)
            .setInHeader("Client-ID \(clientID)", forKey: .authorization)
            .multipart(self.imageEncoder)
            .decode(Void.self)
            .onCompletion({ print("Multipart request result:", $0) })
            .start()
        self.add(task: task)
    }
    
    func update() {
        let task = self.restler
            .put(Endpoint.comment(1))
            .body(self.comment)
            .decode(Void.self)
            .onCompletion({ result in
                switch result {
                case .success:
                    print("Comment putted")
                case let .failure(error):
                    print(error)
                }
            })
            .start()
        self.add(task: task)
    }
    
    func patch() {
        let task = self.restler
            .patch(Endpoint.comment(1))
            .body(self.comment)
            .decode(Void.self)
            .onCompletion({ result in
                switch result {
                case .success:
                    print("Comment patched")
                case let .failure(error):
                    print(error)
                }
            })
            .start()
        self.add(task: task)
    }
    
    func delete() {
        let task = self.restler
            .delete(Endpoint.comment(self.comment.id))
            .decode(Void.self)
            .onCompletion({ result in
                switch result {
                case .success:
                    print("Comment deleted")
                case let .failure(error):
                    print(error)
                }
            })
            .start()
        self.add(task: task)
    }
    
    func cancelAllTasks() {
        self.tasks.forEach {
            $0.cancel()
            print("Task \($0.identifier) cancelled.")
        }
    }
    
    // MARK: - Private
    private func add(task: RestlerTaskType?) {
        guard let task = task as? Restler.Task else { return }
        self.tasks.update(with: task)
    }
}
