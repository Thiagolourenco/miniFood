//
//  TabItemModel.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 10/05/26.
//

import Foundation

enum TabItemModel: String, CaseIterable {
    case home
    case orders
    case privacy
    case profile
    case settings
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .orders:
            return "Orders"
        case .privacy:
            return "Privacy"
        case .profile:
            return "Profile"
        case .settings:
            return "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house"
        case .orders:
            return "cart"
        case .privacy:
            return "lock.shield"
        case .profile:
            return "person"
        case .settings:
            return "gear"
        }
    }
}
