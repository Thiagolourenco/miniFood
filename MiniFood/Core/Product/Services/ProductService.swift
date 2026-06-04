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
            
            print("ResultProduct", resultData)
            return resultData
        } catch {
            print("error",error)
            throw error
        }
//        try await ProductAPI.getProduct(productID: productID)
        
    }
}
