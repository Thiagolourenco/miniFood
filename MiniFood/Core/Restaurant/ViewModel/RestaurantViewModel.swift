//
//  RestaurantViewModel.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 03/06/26.
//

import Foundation

@Observable
class RestaurantViewModel {
    var restaurant: RestaurantModel? = nil
    var products: [ProductModel] = []
    
    var service: RestaurantProtocol
    
    init(service: RestaurantProtocol = RestaurantService()) {
        self.service = service
    }
    
    func loadRestaurantDetails(id: String) async {
        do {
            let result = try await service.getRestaurantDetails(id: id)
            print("result", result)
            restaurant = result.restaurant
            products = result.products
        } catch {
            print(error)
        }
    }
}
