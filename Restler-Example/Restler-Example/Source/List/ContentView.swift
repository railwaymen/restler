//
//  ContentView.swift
//  Restler-Example
//
//  Created by Bartłomiej Świerad on 21/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        List(self.viewModel.posts) { [viewModel = self.viewModel] post in
            NavigationLink(post.title, destination: PostView(viewModel: viewModel.createPostViewModel(post: post)))
        }
        .navigationBarItems(
            trailing: NavigationLink(
                "Downloads",
                destination: DownloadsView(viewModel: viewModel.createDownloadsViewModel())))
    }
}
