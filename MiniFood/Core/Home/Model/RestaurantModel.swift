//
//  RestaurantModel.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 01/06/26.
//
//

import Foundation

struct RestaurantModel: Codable, Identifiable {
    var id: String
    var name: String
    var category: String
    var rating: Double
    var deliveryTimeMin: Int
    var deliveryTimeMax: Int
    var imageUrl: String
    var logoUrl: String
    var badge: String?
    var promoText: String?
    var isFeatured: Bool
}
