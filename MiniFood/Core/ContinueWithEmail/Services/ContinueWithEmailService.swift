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
    func login(email: String, password: String) async throws -> UserReponse
}

struct ContinueWithEmailService: ContinueWithEmailProtocol {
    private let keychainService: KeychainService = .shared
    private let client: ApiClient
    
    init() {
        self.client = ApiClient(baseURL: URLConstants.fakeStoreAPI)
    }
    
    func validEmail(email: String) async throws -> ValidEmailModel {
        
        let payload = try JSONEncoder().encode(["email": email])
        
        let requestModel = ApiRequest<ValidEmailModel>(method: .post, path: APIRoute.auth(.validEmail).path, body: payload )
        
        let resultData = try await client.execute(requestModel)

        return resultData
    }
    
    func registerUser(user: UserModel) async throws -> UserReponse {
            
        let payload = try JSONEncoder().encode(user)
        
        let requestModel = ApiRequest<UserReponse>(method: .post, path: APIRoute.auth(.register).path, body: payload)

        do {
            let resultData = try await client.execute(requestModel)
            
            keychainService.save(key: "accessToken", value: resultData.accessToken)
            keychainService.save(key: "refreshToken", value: resultData.refreshToken)
            return resultData
        } catch {
            throw error
        }

    }
    
    func login(email: String, password: String) async throws -> UserReponse {
        let body = LoginRequest(email: email, password: password)
        let payload = try JSONEncoder().encode(body)
                
        let requestModel = ApiRequest<UserReponse>(method: .post, path: APIRoute.auth(.login).path, body: payload)
        
        do {
            let resultData = try await client.execute(requestModel)
            
            keychainService.save(key: "accessToken", value: resultData.accessToken)
            keychainService.save(key: "refreshToken", value: resultData.refreshToken)

            return resultData
        } catch {
            print(error)
            throw error
        }
    }
    
    // RefreshToken - Colocar em outra parte, analisar qual seria o melhor local
  
    
}
