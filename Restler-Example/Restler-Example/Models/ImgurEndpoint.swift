//
//  ImgurEndpoint.swift
//  Restler-Example
//
//  Created by Bartłomiej Świerad on 16/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import Foundation
import RestlerCore

enum ImgurEndpoint: RestlerEndpointable {
    case upload
    
    var restlerEndpointValue: String {
        switch self {
        case .upload: return "/upload"
        }
    }
}
