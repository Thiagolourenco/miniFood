//
//  SettingsViewModel.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 25/05/26.
//

import Foundation

@Observable
class SettingsViewModel {
    var isLogout: Bool = false
    
    func logout(sessionManager: SessionManager) {
        sessionManager.logout()
        isLogout = true
    }
}
