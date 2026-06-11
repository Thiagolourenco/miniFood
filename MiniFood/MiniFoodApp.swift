//
//  MiniFoodApp.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 06/05/26.
//

import SwiftUI

@main
struct MiniFoodApp: App {
    @State private var manageSession = SessionManager()
    @State private var cartManager = CartManager()
    
    var body: some Scene {
        WindowGroup {
            ManagerAuth()
                .environment(manageSession)
                .environment(cartManager)
        }
    }
}
