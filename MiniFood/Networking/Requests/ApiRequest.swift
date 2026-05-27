//
//  ApiRequest.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 26/05/26.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct ApiRequest<Response: Decodable>{
    let method: HttpMethod
    let path: String
    var queryItems: [URLQueryItem]
    var headers: [String: String]
    var body: Data?
    
    init(method: HttpMethod, path: String, queryItems: [URLQueryItem] = [], headers: [String : String] = [:], body: Data? = nil) {
        self.method = method
        self.path = path
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
        
        if self.headers["Content-Type"] == nil {
            self.headers["Content-Type"] = "application/json"
        }
    }
    
    func makeUrlRequest(defaultHeaders: [String:String]?) throws -> URLRequest {
        guard var components = URLComponents(
            url: URLConstants.fakeStoreAPI.appendingPathComponent(path),
            resolvingAgainstBaseURL: true
        ) else {
            throw URLError(.badURL)
        }
        
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        guard var mergedHeaders = defaultHeaders else {
            throw URLError(.badURL)
        }
        
        mergedHeaders.merge(headers) { (_, new) in new }
        request.allHTTPHeaderFields = mergedHeaders
        
        request.httpBody = body
        
        return request
    }
    
}
