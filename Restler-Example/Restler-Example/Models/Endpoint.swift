//
//  Endpoint.swift
//  Restler-Example
//
//  Created by Bartłomiej Świerad on 04/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation
import Restler

enum Endpoint: RestlerEndpointable {
    case comment(Int)
    case comments
    case posts
    case users
    
    var stringValue: String {
        switch self {
        case let .comment(id): return "/comments/\(id)"
        case .comments: return "/comments"
        case .posts: return "/posts"
        case .users: return "/users"
        }
    }
}
