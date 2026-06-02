//
//  ApiClient.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 26/05/26.
//

import Foundation

struct ApiClient {
    var baseURL: URL
    var session: URLSession = .shared
    var decoder: JSONDecoder = JSONDecoder()
            
    // # TODO: Improve this func, separate 
    func execute<Response>(_ requestModel: ApiRequest<Response>) async throws -> Response {
        var headers: [String: String] = [:]

        if let accessToken = KeychainService.shared.read(key: "accessToken"), !accessToken.isEmpty {
            headers["Authorization"] = "Bearer \(accessToken)"
        }
        
        let request = try requestModel.makeUrlRequest(defaultHeaders: headers)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode == 401 {
            try await refreshToken()
            
            if let accessToken = KeychainService.shared.read(key: "accessToken"), !accessToken.isEmpty {
                headers["Authorization"] = "Bearer \(accessToken)"
            }
            
            let request = try requestModel.makeUrlRequest(defaultHeaders: headers)
            
            let (data, httpResponse) = try await URLSession.shared.data(for: request)
            
            guard let retryReponse = httpResponse as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            guard (200...299).contains(retryReponse.statusCode) else {
                let apiError = try? decoder.decode(ApiResponseError.self, from: data)
                
                throw AuthServiceError.api(
                    message: apiError?.error.message ?? "Request failed with status code \(retryReponse.statusCode)"
                )
                
            }
            
            return try JSONDecoder().decode(Response.self, from: data)
        }
        
        if !(200...299).contains(httpResponse.statusCode) {
            let apiError = try JSONDecoder().decode(ApiResponseError.self, from: data)
            
            throw AuthServiceError.api(message: apiError.error.message)
        }

        return try JSONDecoder().decode(Response.self, from: data)

    }
}

extension ApiClient {
    func refreshToken() async throws {
        guard let refreshToken = KeychainService.shared.read(key: "refreshToken") else {
            throw AuthServiceError.api(message: "Token invalid")
        }
        
        let url = baseURL.appending(path: APIRoute.auth(.refreshToken).path)
        
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
            KeychainService.shared.delete(key: "accessToken")
            KeychainService.shared.delete(key: "refreshToken")
            
            return
        }

        let resultData = try JSONDecoder().decode(RefreshToken.self, from: data)
        
        KeychainService.shared.save(key: "accessToken", value: resultData.accessToken)
        KeychainService.shared.save(key: "refreshToken", value: resultData.refreshToken)

        
        print("result", resultData)
//        KeychainService.shared.save(key: "accessToken", value: resultData.)
//        KeychainService.shared.save(key: "refreshToken", value: resultData.refreshToken())
//        let refreshToken = keychainService.read(key: "refreshToken")
//        let payload = try JSONEncoder().encode(["refreshToken": refreshToken])
//        
//        let requestModel = ApiRequest<RefreshToken>(method: .post, path: APIRoute.auth(.refreshToken).path, body: payload)
//        
//        do {
//            let resultData = try await client.execute(requestModel)
//            
//            keychainService.save(key: "accessToken", value: resultData.accessToken)
//            keychainService.save(key: "refreshToken", value: resultData.refreshToken)
//
//        } catch {
//            print(error)
//            throw error
//        }
    }
}
