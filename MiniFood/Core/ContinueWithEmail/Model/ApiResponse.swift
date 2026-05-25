//
//  ApiResponse.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 21/05/26.
//

import Foundation

struct ApiResponseError: Decodable {
    let error: ApiErrorDetails
}

struct ApiErrorDetails: Decodable {
    let code: String
    let message: String
}
