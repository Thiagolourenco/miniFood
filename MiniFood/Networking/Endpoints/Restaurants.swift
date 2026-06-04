//
//  Restaurants.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 03/06/26.
//

//
//  HomeSection.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 01/06/26.
//

import Foundation

enum RestaurantEndpoint {
    case restaurants
    case restaurantDetails(id: String)
    
    
    var path: String {
        switch self {
        case .restaurants:
            return "restaurants"
        case .restaurantDetails(let id):
            return "restaurants/\(id)"
        }
    }
}

//enum HomeSection {
//    case restaurants ([RestaurantModel])
//}
