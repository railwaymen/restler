//
//  DownloadsViewModel.swift
//  Restler-Example
//
//  Created by Bartłomiej Świerad on 29/09/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation
import Combine
import RestlerCore

final class DownloadsViewModel: ObservableObject {
    let objectWillChange: ObservableObjectPublisher = .init()
    
    @Published var urlString: String = ""
    
    private(set) var progress: Progress? = nil {
        willSet {
            objectWillChange.send()
            isProgressHidden = newValue == nil
        }
    }
    
    private(set) var isProgressHidden: Bool = true {
        willSet { objectWillChange.send() }
    }
    
    private var url: URL? {
        URL(string: urlString)
    }
    
    // MARK: - Initialization
    init() {}
    
    // MARK: - Internal
    func download() {
        guard let url = self.url else { return }
        Restler(baseURL: url)
            .get("")
            .receive(on: .main)
            .requestDownload()
            .subscribe(
                onProgress: { [weak self] task in
                    self?.progress = task.progress
                },
                onSuccess: { fileURL in
                    print("Successful download to:", fileURL)
                },
                onError: { error in
                    print("Download error:", error)
                },
                onCompletion: { [weak self] _ in
                    self?.progress = nil
                })
    }
}
