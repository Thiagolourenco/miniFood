//
//  CartManager.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 11/06/26.
//

import Foundation

@Observable
class CartManager {
    var cart: [CartModel] = [
        CartModel(id: "123", name: "Produto 1"),
        CartModel(id: "1234", name: "Produto 2"),
        CartModel(id: "12343", name: "Produto 2"),

    ]
    var count: Int {
        cart.count
    }
    
    // teste
    func addCart() {
        cart.append(CartModel(id: "122343", name: "Produto 2"))
    }
}
