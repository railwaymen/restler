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
        VStack(spacing: 16) {
            Button(
                action: self.viewModel.create,
                label: {
                    Text("POST")
            })
            Button(
                action: self.viewModel.update,
                label: {
                    Text("PUT")
            })
            Button(
                action: self.viewModel.patch,
                label: {
                    Text("PATCH")
            })
            Button(
                action: self.viewModel.delete,
                label: {
                    Text("DELETE")
            })
            Button(
                action: self.viewModel.cancelAllTasks,
                label: {
                    Text("CANCEL ALL TASKS")
            }).padding(.top, 16)
        }
    }
}
