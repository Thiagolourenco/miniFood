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
        let request = try requestModel.makeUrlRequest(defaultHeaders: [:])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if !(200...299).contains(httpResponse.statusCode) {
            let apiError = try JSONDecoder().decode(ApiResponseError.self, from: data)
            
            throw AuthServiceError.api(message: apiError.error.message)
        }

        return try JSONDecoder().decode(Response.self, from: data)

    }
}
