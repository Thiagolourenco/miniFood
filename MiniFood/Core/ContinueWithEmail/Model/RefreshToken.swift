//
//  RefreshToken.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 02/06/26.
//

import Foundation

struct RefreshToken: Decodable {
    let accessToken: String
    let refreshToken: String
}
