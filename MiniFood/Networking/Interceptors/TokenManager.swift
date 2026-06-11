//
//  TokenManager.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 09/06/26.
//

import Foundation

actor TokenManager {
    private var refreshTask: Task<Void, Error>?
    let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func refreshIfNeeded() async throws {
        if let refreshTask {
            try await refreshTask.value
            return
        }
        
        let task = Task {
            try await self.refreshToken()
        }
        
        refreshTask = task
        
        do {
            try await task.value
            refreshTask = nil
        } catch {
            refreshTask = nil
            throw error
        }
    }
    
    private func refreshToken() async throws {
        guard let refreshToken = await KeychainService.shared.read(key: "refreshToken") else {
            throw AuthServiceError.api(message: "Token invalid")
        }
        
        let url = await baseURL.appending(path: APIRoute.auth(.refreshToken).path)
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload = try JSONEncoder().encode(["refreshToken": refreshToken])
        request.httpBody = payload
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthServiceError.api(message: "Ocurred error")
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            await KeychainService.shared.delete(key: "accessToken")
            await KeychainService.shared.delete(key: "refreshToken")
            
            throw AuthServiceError.api(message: "Refresh token expired")
        }

        let resultData = try JSONDecoder().decode(RefreshToken.self, from: data)
        
        await KeychainService.shared.save(key: "accessToken", value: resultData.accessToken)
        await KeychainService.shared.save(key: "refreshToken", value: resultData.refreshToken)

    }

}
