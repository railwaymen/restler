//
//  ImgurEndpoint.swift
//  Restler-Example
//
//  Created by Bartłomiej Świerad on 16/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation
import Restler

enum ImgurEndpoint: RestlerEndpointable {
    case upload
    
    var stringValue: String {
        switch self {
        case .upload: return "/upload"
        }
    }
}
