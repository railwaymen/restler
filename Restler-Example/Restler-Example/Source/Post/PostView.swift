//
//  PostView.swift
//  Restler-Example
//
//  Created by Bartłomiej Świerad on 24/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import SwiftUI

struct PostView: View {
    @ObservedObject var viewModel: PostViewModel
    
    var body: some View {
        List(self.viewModel.comments) { comment in
            NavigationLink(comment.body, destination: CommentView(viewModel: self.viewModel.createViewModel(for: comment)))
        }
        .onAppear {
            self.viewModel.viewAppears()
        }
    }
}
