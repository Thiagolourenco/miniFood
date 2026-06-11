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
    
    let tokenManager: TokenManager
    
    init(baseURL: URL, decoder: JSONDecoder, requestModel: ApiRequest<Response>, headers: [String : String]) {
        self.baseURL = baseURL
        self.decoder = decoder
        self.requestModel = requestModel
        self.headers = headers
        self.tokenManager = TokenManager(baseURL: baseURL)
    }
    
    
    func retry() async throws -> Response {
        try await tokenManager.refreshIfNeeded()
        
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
    
}
