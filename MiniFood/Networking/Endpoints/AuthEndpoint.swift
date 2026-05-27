//
//  AuthEndpoint.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 27/05/26.
//

import Foundation

enum AuthEndpoint {
    case validEmail
    case register
    case login
    
    var path: String {
        switch self {
        case .validEmail:
            return "auth/check-email"
        case .register:
            return "auth/register"
        case .login:
            return "auth/login"
        }
    }
}
