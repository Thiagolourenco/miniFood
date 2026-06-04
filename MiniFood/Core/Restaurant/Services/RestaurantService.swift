//
//  RestaurantService.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 03/06/26.
//

import Foundation

enum RestaurantDataResult {
    case restaurant(RestaurantModel)
    case products([ProductModel])
}

// Ir para Model
struct RestaurantDetailsData {
    let restaurant: RestaurantModel
    let products: [ProductModel]
}

protocol RestaurantProtocol {
    func getRestaurantDetails(id: String) async throws -> RestaurantDetailsData
//    func getRestaurants(id: String) async throws -> RestaurantModel
}

struct RestaurantService: RestaurantProtocol {
    private let client: ApiClient
    
    init() {
        self.client = ApiClient(baseURL: URLConstants.fakeStoreAPI)
    }
    
    func getRestaurantDetails(id: String) async throws -> RestaurantDetailsData {
        var restaurantResult: RestaurantModel?
        var productsResult: [ProductModel] = []
        
        do {
            try await withThrowingTaskGroup(of: RestaurantDataResult.self) { group in
                var section: [RestaurantDataResult] = []
                group.addTask {
                    let restaurant = try await getRestaurants(id: id)
                    
                    return .restaurant(restaurant)
                }
                
                group.addTask {
                    let products = try await getProductByRestaurant(id: id)
                    
                    return .products(products)
                }
                
                for try await result in group {
                    switch result {
                    case .restaurant(let restaurant):
                        restaurantResult = restaurant
                    case .products(let products):
                        productsResult = products
                    }
                }
            }
            
            guard let restaurant = restaurantResult else {
                throw URLError(.badServerResponse)
            }
            
            return RestaurantDetailsData(
                restaurant: restaurant,
                products: productsResult
            )
            
            //            return section
        } catch {
            print("Error", error)
            throw error
        }
    }
    
    
    private func getProductByRestaurant(id: String) async throws -> [ProductModel] {
        do {
            let requestModel = ApiRequest<[ProductModel]>(method: .get, path: APIRoute.product(.restaurantsByProduct(restaurantID: id)).path)
            
            let resultData = try await client.execute(requestModel)
            
            print("ResultProduct", resultData)
            return resultData
        }
    }
    
    private func getRestaurants(id: String) async throws -> RestaurantModel {
        do {
            let requestModel = ApiRequest<RestaurantModel>(method: .get, path: APIRoute.restaurant(.restaurantDetails(id: id)).path)

            let resultData = try await client.execute(requestModel)
            
            print("result", resultData)
            return resultData
        } catch {
            throw error
        }
    }
}


