//
//  ProductViewModel.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 03/06/26.
//

import Foundation

@Observable
class ProductViewModel {
    var product: ProductModel? = nil
    private let service: ProductServiceProtocol = ProductService()
    
    func getProduct(productID: String) async {
        do {
            let result = try await service.getProduct(productID: productID)
            
            product = result
        } catch {
            print("err", error)
        }
    }
}
