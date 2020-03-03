//
//  CommentView.swift
//  Restler-Example
//
//  Created by Bartłomiej Świerad on 03/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import SwiftUI

struct CommentView: View {
    @ObservedObject var viewModel: CommentViewModel
    
    var body: some View {
        VStack {
            Button(
                action: self.viewModel.create,
                label: {
                    Text("Post")
            })
        }
    }
}
