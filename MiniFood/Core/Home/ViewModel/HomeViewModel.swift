//
//  HomeViewModel.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 01/06/26.
//

import Foundation

/*
 1 - Get list categories
 2 - Get list restaurants 
 */

@Observable
class HomeViewModel {
    var categoriesResult: [CategoryModel] = []
    var restaurantsResult: [RestaurantModel] = []
    
    private let service: HomeServiceProtocol = HomeService()

    init() {
        print("categories", restaurantsResult)
    }
    
    func load() async {
        do {
            let result = try await service.getHomeData()

            for section in result {
                switch section {
                case .categories(let categories):
                    print("category", categories)
                    categoriesResult = categories
                case .restaurants(let restaurants):
                    restaurantsResult = restaurants
                }
            }
        } catch {
            print("error", error)
        }
    }
}
