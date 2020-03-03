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
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    // MARK: - Initialization
    init(comment: PostComment) {
        self.comment = comment
    }
    
    // MARK: - Internal
    func create() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/comments") else { return assertionFailure() }
        do {
            try self.post(url: url)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    // MARK: - Private
    private func post(url: URL) throws {
        try self.restler.post(url: url, content: self.comment) { result in
            switch result {
            case .success:
                print("Comment posted")
            case let .failure(error):
                print(error)
            }
        }
    }
}
