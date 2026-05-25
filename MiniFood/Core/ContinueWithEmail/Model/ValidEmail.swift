//
//  ValidEmail.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 20/05/26.
//

import Foundation

struct ValidEmailModel: Decodable {
    let exists: Bool?
    let authProvider: String?
    
    init(exists: Bool?, authProvider: String?) {
        self.exists = exists
        self.authProvider = authProvider
    }
    
}
