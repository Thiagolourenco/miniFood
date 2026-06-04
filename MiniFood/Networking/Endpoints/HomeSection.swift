//
//  HomeSection.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 01/06/26.
//

import Foundation

enum HomeSectionEndpoint {
    case categories
    case restaurants
    
    var path: String {
        switch self {
        case .categories:
            return "categories"
        case .restaurants:
            return "restaurants"
        }
    }
}

enum HomeSection {
    case categories ([CategoryModel])
    case restaurants ([RestaurantModel])
}
