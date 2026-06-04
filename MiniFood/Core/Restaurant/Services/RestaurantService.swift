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
            
            return resultData
        }
    }
    
    private func getRestaurants(id: String) async throws -> RestaurantModel {
        do {
            let requestModel = ApiRequest<RestaurantModel>(method: .get, path: APIRoute.restaurant(.restaurantDetails(id: id)).path)

            let resultData = try await client.execute(requestModel)
            
            return resultData
        } catch {
            throw error
        }
    }
}


final class MockRestaurantService: RestaurantProtocol {
    func getRestaurantDetails(id: String) async throws -> RestaurantDetailsData {
        return RestaurantDetailsData(
            restaurant: RestaurantModel(
                id: "009c2b16-f4e2-44d5-8037-0b286c63aa60", name: "Sushi Tokyo", category: "Sushi", rating: 4.8, deliveryTimeMin: 30, deliveryTimeMax: 45, imageUrl: "https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?auto=format&fit=crop&w=800&q=80", logoUrl: "https://images.unsplash.com/photo-1611141647817-1bf24c2b6ec0?auto=format&fit=crop&w=200&q=80", badge: Optional("Top Rated"), promoText: nil, isFeatured: true
            ),
            products: [
                ProductModel(id: "145e7e57-9649-4d30-8222-e6dab79b1e7c", restaurantId: "009c2b16-f4e2-44d5-8037-0b286c63aa60", title: "Salmon Sashimi (10pc)", subtitle: "Fresh salmon slices", description: "10 generous slices of premium, freshly cut Atlantic salmon. Served with wasabi, ginger and soy sauce.", price: "18.50", currency: "USD", rating: 4.9, reviewCount: 1530, imageUrl: "https://images.unsplash.com/photo-1607301406259-dfb186e15de8?auto=format&fit=crop&w=800&q=80", filterTag: "POPULAR", modifiers: []),
                ProductModel(id: "f37dc16d-ddcc-4793-861f-b08ff7d1eed5", restaurantId: "009c2b16-f4e2-44d5-8037-0b286c63aa60", title: "Sushi Platter (16pc)", subtitle: "Chef selection of nigiri & maki", description: "A curated selection of 8 nigiri and 8 maki rolls, including salmon, tuna, shrimp and California rolls.", price: "32.00", currency: "USD", rating: 4.8, reviewCount: 940, imageUrl: "https://images.unsplash.com/photo-1553621042-f6e147245754?auto=format&fit=crop&w=800&q=80", filterTag: "PICKS_FOR_YOU", modifiers: [MiniFood.Modifier(id: "f6df1a0f-e489-4d00-bfda-23d592c5d91b", name: "Extra Wasabi", price: "0.00"), MiniFood.Modifier(id: "96e239eb-0ccf-44dd-a7a0-4172b284163a", name: "Extra Ginger", price: "0.00"), MiniFood.Modifier(id: "797a7ee0-32c4-4023-bdcb-1fb6b4b8b0d2", name: "Spicy Mayo", price: "0.50")]),
                ProductModel(id: "3d5b638c-62f5-4e3c-8588-851966016fae", restaurantId: "009c2b16-f4e2-44d5-8037-0b286c63aa60", title: "Salmon Roll (8pc)", subtitle: "Classic salmon maki", description: "Eight pieces of fresh salmon and rice rolled in seaweed.", price: "12.50", currency: "USD", rating: 4.7, reviewCount: 720, imageUrl: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80", filterTag: "PICKS_FOR_YOU", modifiers: [])
            ]
        )
    }
}
