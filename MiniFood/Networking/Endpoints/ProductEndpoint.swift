//
//  ProductEndpoint.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 03/06/26.
//

import Foundation

enum ProductEndpoint {
    case restaurantsByProduct(restaurantID: String)
    case getProduct(productID: String)
    
    var path: String {
        switch self {
        case .restaurantsByProduct(let restaurantID):
            return "restaurants/\(restaurantID)/products"
        case .getProduct(let productID):
            return "products/\(productID)"
        }
    }
}
