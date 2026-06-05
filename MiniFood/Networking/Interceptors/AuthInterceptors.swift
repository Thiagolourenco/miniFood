//
//  AuthInterceptors.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 05/06/26.
//

import Foundation

final class AuthInterceptors<Response: Decodable> {
    var baseURL: URL
    var decoder: JSONDecoder
    var requestModel: ApiRequest<Response>
    var headers: [String: String]
    
    init(baseURL: URL, decoder: JSONDecoder, requestModel: ApiRequest<Response>, headers: [String : String]) {
        self.baseURL = baseURL
        self.decoder = decoder
        self.requestModel = requestModel
        self.headers = headers
    }
    
    func retry() async throws -> Response {
        try await refreshToken()
        
        if let accessToken = KeychainService.shared.read(key: "accessToken"), !accessToken.isEmpty {
            self.headers["Authorization"] = "Bearer \(accessToken)"
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
    
    private func refreshToken() async throws {
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

    }
}
