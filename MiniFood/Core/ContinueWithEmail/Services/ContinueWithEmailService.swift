//
//  ContinueWithEmailService.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 20/05/26.
//

import Foundation

protocol ContinueWithEmailProtocol {
    func validEmail(email: String) async throws -> ValidEmailModel
    func registerUser(user: UserModel) async throws -> UserReponse
}

struct ContinueWithEmailService: ContinueWithEmailProtocol {
    let url: URL = URL(string: "http://localhost:3000/v1/")!
    
    func validEmail(email: String) async throws -> ValidEmailModel {
        
        let endpoint = url.appending(path: "auth/check-email")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: ["email": email])
        
        let (data, response) = try await URLSession.shared.data(for: request)
                
        let newData = try JSONDecoder().decode(ValidEmailModel.self, from: data)
     
        return newData
    }
    
    func registerUser(user: UserModel) async throws -> UserReponse {
        let endpoint = url.appending(path: "auth/register")
        let newData = try JSONEncoder().encode(user)
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = newData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                let apiError = try JSONDecoder().decode(ApiResponseError.self, from: data)
                
                throw AuthServiceError.api(message: apiError.error.message)
            }
            
            let resultData = try JSONDecoder().decode(UserReponse.self, from: data)
            
            print("resultData \(resultData)")
            return resultData
        } catch {
            throw error
        }
       
    }
    
    
    
}

