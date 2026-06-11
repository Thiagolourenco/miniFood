//
//  RefreshToken.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 02/06/26.
//

import Foundation


nonisolated struct RefreshToken: Decodable, Sendable {
    let accessToken: String
    let refreshToken: String
}
