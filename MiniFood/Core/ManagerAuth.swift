//
//  ManagerAuth.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 25/05/26.
//

import SwiftUI

@Observable
final class SessionManager {
    var isAuthenticated: Bool = false
    
    init() {
     checkSession()
    }
    
    func checkSession() {
        let token = KeychainService.shared.read(key: "accessToken")
        
        guard token != nil else {
            isAuthenticated = false
            return
        }
            
        isAuthenticated = true
    }
    
    func logout() {
        KeychainService.shared.delete(key: "accessToken")
        KeychainService.shared.delete(key: "refreshToken")
        
        isAuthenticated = false
    }
}

struct ManagerAuth: View {
    @Environment(SessionManager.self) private var sessionManager

    var body: some View {
        Group {
            if sessionManager.isAuthenticated {
                MainTabView()
            } else {
                Login()
            }
        }
    }
}

#Preview {
    ManagerAuth()
}
