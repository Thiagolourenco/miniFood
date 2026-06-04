//
//  ProductModel.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 03/06/26.
//

import Foundation

struct Modifier: Codable, Identifiable {
    let id: String
    let name: String
    let price: String
}

struct ProductModel: Codable, Identifiable {
    let id: String
    let restaurantId: String
    let title: String
    let subtitle: String
    let description: String
    let price: String
    let currency: String
    let rating: Double
    let reviewCount: Int
    let imageUrl: String
    let filterTag: String
    let modifiers: [Modifier]
}
