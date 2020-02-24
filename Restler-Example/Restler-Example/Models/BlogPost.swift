//
//  BlogPost.swift
//  Restler-Example
//
//  Created by Bartłomiej Świerad on 21/02/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation

struct BlogPost: Decodable, Identifiable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}
