//
//  CategoryModel.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 01/06/26.
//

import Foundation

struct CategoryModel: Decodable, Identifiable {
    let id: String
    let name: String
    let iconUrl: String
}
