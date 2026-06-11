//
//  CartManager.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 11/06/26.
//

import Foundation

@Observable
class CartManager {
    var cart: [ProductModel] = []
    var count: Int {
        cart.count
    }
    
    // teste
    func addCart(cartItem: ProductModel) {
        // ADicionar validação para produtos que esteja duplicado, gerando um contador para mostrar a quantidade, e não duplicando o mesmo id dentro do array
//        if let productExists = cart.first(where: { $0.id == cartItem.id }) {
//            productExists.price += cartItem.price
//            return
//        }
        
        cart.append(cartItem)
    }
}
