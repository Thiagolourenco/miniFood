//
//  ImageLoader.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 02/06/26.
//

import SwiftUI

@Observable
class ImageLoaderViewModel {
    var image: UIImage?
    var isLoading: Bool = false
    
    func loadImage(url: String) async throws -> Void {
        isLoading = true
        
        do {
            guard let uriImage = URL(string: url) else {
                throw URLError(.badURL)
            }
            
            let (data, _) = try await URLSession.shared.data(from: uriImage)
            
            guard let imageResult = UIImage(data: data) else {
                throw URLError(.badServerResponse)
            }
            
            isLoading = false
            image = imageResult
            
        } catch {
            isLoading = false
        }
      
    }
}

struct ImageLoader: View {
    @State var imageUrl: String
    @State private var viewModel: ImageLoaderViewModel = ImageLoaderViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let image = viewModel.image{
                Image(uiImage: image)
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Image(systemName: "fork.knife")
                    .resizable()
                    .scaledToFit()
            }
        }
        .task {
            do {
                try await viewModel.loadImage(url: imageUrl)
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    ImageLoader(imageUrl: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=200&q=80")
}
