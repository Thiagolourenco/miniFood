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
        let requestModel = ApiRequest<[RestaurantModel]>(method: .get, path: APIRoute.restaurant(.restaurants).path)
        
        do {
            let resultData = try await client.execute(requestModel)
            
            return resultData
        } catch {
            throw error
        }
    
    }
}

final class MockHomeService: HomeServiceProtocol {
    func getHomeData() async throws -> [HomeSection] {
        return [
            .categories([
                CategoryModel(id: "3181b5ea-2c5d-4acf-90c1-53ff6b7b2a9b", name: "Fast Food", iconUrl: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=200&q=80"),
                CategoryModel(id: "55064e1c-f10d-49d9-8691-a790f0282de0", name: "Pizza", iconUrl: "https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=200&q=80")
            ]),
            .restaurants([
                RestaurantModel(id: "956c8910-d731-465c-b567-c1c4b5c60419", name: "Sweet Dreams", category: "Desserts", rating: 4.9, deliveryTimeMin: 25, deliveryTimeMax: 40, imageUrl: "https://images.unsplash.com/photo-1551024601-bec78aea704b?auto=format&fit=crop&w=800&q=80", logoUrl: "https://images.unsplash.com/photo-1488477181946-6428a0291777?auto=format&fit=crop&w=200&q=80", badge: Optional("New Open"), promoText: nil, isFeatured: true),
                RestaurantModel(id: "009c2b16-f4e2-44d5-8037-0b286c63aa60", name: "Sushi Tokyo", category: "Sushi", rating: 4.8, deliveryTimeMin: 30, deliveryTimeMax: 45, imageUrl: "https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?auto=format&fit=crop&w=800&q=80", logoUrl: "https://images.unsplash.com/photo-1611141647817-1bf24c2b6ec0?auto=format&fit=crop&w=200&q=80", badge: Optional("Top Rated"), promoText: nil, isFeatured: true)

            ])
        ]
    }
}
