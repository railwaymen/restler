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
    private let restler: Restlerable = Restler()
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    var posts: [BlogPost] = [] {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    init() {
        self.fetchData()
    }
    
    // MARK: - Private
    private func fetchData() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return assertionFailure() }
        self.restler.get(url: url) { (result: Result<[BlogPost], Error>) in
            switch result {
            case let .success(posts):
                self.posts = posts
            case let .failure(error):
                print("Error:", error)
            }
        }
    }
}
