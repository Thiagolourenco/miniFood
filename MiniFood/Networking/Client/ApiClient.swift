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
            let resulRetry = try await AuthInterceptors<Response>(
                baseURL: baseURL,
                decoder: decoder,
                requestModel: requestModel,
                headers: headers).retry()
            
            return resulRetry
        }
        
        if !(200...299).contains(httpResponse.statusCode) {
            let apiError = try JSONDecoder().decode(ApiResponseError.self, from: data)
            
            throw AuthServiceError.api(message: apiError.error.message)
        }

        return try JSONDecoder().decode(Response.self, from: data)

    }
}
