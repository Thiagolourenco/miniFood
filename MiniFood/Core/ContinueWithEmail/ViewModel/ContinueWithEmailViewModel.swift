//
//  ContinueWithEmailViewModel.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 20/05/26.
//

import Foundation

@Observable
class ContinueWithEmailViewModel {
    var userNotRegistered: Bool = true
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var name: String = ""
    var isLoading: Bool = false

    var shouldEnterTheApp: Bool = false
    var errorMessage: String? = nil
    
    private let service: ContinueWithEmailProtocol
    
    init(service: ContinueWithEmailProtocol) {
        self.service = service
    }
    
    func validEmail() async throws -> Void {
        let parts = email.split(separator: "@")
        print("parts \(parts)")
        guard parts.count == 2, parts[1].contains(".") else { return }
        
        do {
           let resultData = try await service.validEmail(email: email)

            userNotRegistered = resultData.exists ?? false
            print("Sucesso")
        } catch {
            print(error)
            throw error
        }
        return
    }
    
    func registerUser() async -> Void {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        guard case let passwordConfirmed as String? = password, passwordConfirmed == confirmPassword else {
            // Show toast mensage Success or Error
            print("Deu Error")
            errorMessage = "Password is not the same"
            return
        }
        

        let userData = UserModel(name: name, email: email, password: password)
        
        print("userData \(userData)")
        
        do {
            _ = try await service.registerUser(user: userData)

            isLoading = false
            shouldEnterTheApp = true
            print("User")
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            shouldEnterTheApp = false
            print("Error \(error)")
        }
        
        return
    }
    
    func login() async -> Void {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }

        
        do {
            _ = try await service.login(email: email, password: password)

            isLoading = false
            shouldEnterTheApp = true
            print("User")
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            shouldEnterTheApp = false
            print("Error \(error)")
        }
        
    }
}

