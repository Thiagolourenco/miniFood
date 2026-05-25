//
//  KeychainService.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 25/05/26.
//

import Foundation
import Security

final class KeychainService {
    static let shared = KeychainService()
    
    private init() {}
    
    // Value is the accessToken, refreshToken
    func save(key: String, value: String) {
        let data = Data(value.utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary) // Deleta qualquer coisa que esteja salva, removendo o lixo
        SecItemAdd(query as CFDictionary, nil) // Após rever se tem algo ou não
    }
    
    func read(key: String) -> String! {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        
        SecItemCopyMatching(
            query as CFDictionary,
            &result
        )
        
        guard let data = result as? Data else { return nil }
        
        return String(data: data, encoding: .utf8)
    }
    
    func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
