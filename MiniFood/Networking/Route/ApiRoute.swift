//
//  ApiRoute.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 27/05/26.
//

import Foundation

struct URLConstants {
    static let fakeStoreAPI: URL = URL(string: "http://localhost:3000/v1/")!
}

enum APIRoute {
    case auth(AuthEndpoint)
    
    var path: String {
        switch self {
        case .auth(let endpoint):
            return endpoint.path
        }
    }
}
