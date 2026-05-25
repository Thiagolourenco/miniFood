//
//  AuthServiceError.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 21/05/26.
//

import Foundation

enum AuthServiceError: Error, LocalizedError {
    case invalidReponse
    case api(message: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidReponse:
            return "Invalide server error"
        case .api(let message):
            return message
        }
    }
    
}
