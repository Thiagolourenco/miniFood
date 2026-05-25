//
//  SettignModel.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 11/05/26.
//

import Foundation

struct SettingItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let trailing: String?
    let trailingIcon: String?
    let onAction: (() -> Void)?

    init(icon: String, title: String, trailing: String? = nil, trailingIcon: String? = nil, onAction: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.trailing = trailing
        self.trailingIcon = trailingIcon
        self.onAction = onAction
    }
}
