//
//  ProductService.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 03/06/26.
//

import Foundation

protocol ProductServiceProtocol {
    func getProduct(productID: String) async throws -> ProductModel
}

struct ProductService: ProductServiceProtocol {
    private let client: ApiClient
    
    init() {
        self.client = ApiClient(baseURL: URLConstants.fakeStoreAPI)
    }
    
    func getProduct(productID: String) async throws -> ProductModel {
        do {
            let requestModel = ApiRequest<ProductModel>(method: .get, path: APIRoute.product(.getProduct(productID: productID)).path)
            
            let resultData = try await client.execute(requestModel)
            
            return resultData
        } catch {
            throw error
        }
        
    }
}

final class MockProductService: ProductServiceProtocol {
    func getProduct(productID: String) async throws -> ProductModel {
        return ProductModel(id: "f37dc16d-ddcc-4793-861f-b08ff7d1eed5", restaurantId: "009c2b16-f4e2-44d5-8037-0b286c63aa60", title: "Sushi Platter (16pc)", subtitle: "Chef selection of nigiri & maki", description: "A curated selection of 8 nigiri and 8 maki rolls, including salmon, tuna, shrimp and California rolls.", price: "32.00", currency: "USD", rating: 4.8, reviewCount: 940, imageUrl: "https://images.unsplash.com/photo-1553621042-f6e147245754?auto=format&fit=crop&w=800&q=80", filterTag: "PICKS_FOR_YOU", modifiers: [MiniFood.Modifier(id: "f6df1a0f-e489-4d00-bfda-23d592c5d91b", name: "Extra Wasabi", price: "0.00"), MiniFood.Modifier(id: "96e239eb-0ccf-44dd-a7a0-4172b284163a", name: "Extra Ginger", price: "0.00"), MiniFood.Modifier(id: "797a7ee0-32c4-4023-bdcb-1fb6b4b8b0d2", name: "Spicy Mayo", price: "0.50")])
    }
}
