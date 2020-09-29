//
//  DownloadsView.swift
//  Restler-Example
//
//  Created by Bartłomiej Świerad on 29/09/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import SwiftUI

struct DownloadsView: View {
    @ObservedObject var viewModel: DownloadsViewModel
    
    var body: some View {
        getActiveView()
    }
    
    @ViewBuilder
    private func getActiveView() -> some View {
        if let progress = viewModel.progress {
            ProgressView(progress: progress)
        } else {
            DownloadForm(url: $viewModel.urlString, downloadAction: viewModel.download)
        }
    }
}

struct ProgressView: View {
    let progress: Progress
    
    var body: some View {
        VStack {
            Text("Downloading...")
            ProgressView(progress: progress)
        }
        .padding()
    }
}

private struct DownloadForm: View {
    @Binding var url: String
    let downloadAction: () -> Void
    
    var body: some View {
        VStack {
            TextField("Download URL", text: $url)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Download", action: downloadAction)
        }
        .padding()
    }
}
