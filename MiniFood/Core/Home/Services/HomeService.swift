//
//  HomeService.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 01/06/26.
//

import Foundation

protocol HomeServiceProtocol {
    func getHomeData() async throws -> [HomeSection]
}

struct HomeService: HomeServiceProtocol {
    private let keychainService: KeychainService = .shared
    private let client: ApiClient
    
    init() {
        self.client = ApiClient(baseURL: URLConstants.fakeStoreAPI)
    }

    func getHomeData() async throws -> [HomeSection] {
        let endpoints: [HomeSectionEndpoint] = [
            .categories,
            .restaurants
        ]
        
        let section = try await withThrowingTaskGroup(of: HomeSection.self) { group in
            var sections: [HomeSection] = []
            
            for endpoint in endpoints {
                group.addTask {
                    try await self.fetchSection(endpoint)
                }
            }
            
            for try await section in group {
                sections.append(section)
            }
            
            return sections
        }
        
        return section
    }
    
    private func fetchSection(_ endpoint: HomeSectionEndpoint) async throws -> HomeSection {
        switch endpoint {
            case .categories:
                let categories = try await getCategoryData()
            return .categories(categories)
            case .restaurants:
                let restaurants = try await getRestaurantData()
            return .restaurants(restaurants)
        }
    }
    
    private func getCategoryData() async throws -> [CategoryModel] {
        let requestModel = ApiRequest<[CategoryModel]>(method: .get, path: APIRoute.home(.categories).path)
        
        do {
            let resultData = try await client.execute(requestModel)

            return resultData
        } catch {
            throw error
        }
     
    }
    
    private func getRestaurantData() async throws -> [RestaurantModel] {
        let requestModel = ApiRequest<[RestaurantModel]>(method: .get, path: APIRoute.home(.restaurants).path)
        
        do {
            let resultData = try await client.execute(requestModel)
            
            return resultData
        } catch {
            throw error
        }
    
    }
}
