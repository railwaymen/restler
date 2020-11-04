//
//  ImgurImageEncoder.swift
//  Restler-Example
//
//  Created by Bartłomiej Świerad on 16/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation
import RestlerCore

struct ImgurImageEncoder: Encodable, RestlerMultipartEncodable {
    let title: String
    let description: String
    let image: Restler.MultipartObject
    
    func encodeToMultipart(encoder: RestlerMultipartEncoderType) throws {
        let container = encoder.container(using: CodingKeys.self)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.image, forKey: .image)
    }
}
