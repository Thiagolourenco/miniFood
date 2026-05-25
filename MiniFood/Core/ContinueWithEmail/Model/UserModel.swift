//
//  UserModel.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 20/05/26.
//

import Foundation

struct UserModel: Codable {
    let name: String
    let email: String
    let password: String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct UserReponse: Decodable {
    let user: User
    let accessToken: String
    let refreshToken: String
    
    init(user: User, accessToken: String, refreshToken: String) {
        self.user = user
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

struct User: Decodable {
    let id: String
    let email: String
    let name: String
    let authProvider: String?
    let rewardsPoints: Int
    let balance: String
    let isPro: Bool
    let defaultAddress: String?
    let createdAt: String?
    let updatedAt: String?
}
