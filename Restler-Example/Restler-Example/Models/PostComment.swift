//
//  PostComment.swift
//  Restler-Example
//
//  Created by Bartłomiej Świerad on 24/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

struct PostComment: Codable, Identifiable {
    let id: Int
    let postId: Int
    let name: String
    let email: String
    let body: String
}
