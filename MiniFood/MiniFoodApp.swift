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
    
    var body: some Scene {
        WindowGroup {
            ManagerAuth()
                .environment(manageSession)
        }
    }
}
