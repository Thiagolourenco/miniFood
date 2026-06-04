//
//  RestaurantDetails.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 12/05/26.
//

import SwiftUI

struct Product: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let subtitle: String
    let price: String
}

enum FILTER_SELECTED: String, CaseIterable {
    case PICKS_FOR_YOU = "PICKS_FOR_YOU"
    case NEW_IN = "NEW_IN"
    case POPULAR = "POPULAR"
}

struct RestaurantDetails: View {
    @State var restaurantID: String? = nil
    @Environment(\.dismiss) var goBack
    @State private var showFilter: Bool = false
    @State private var filterSelected: FILTER_SELECTED = .PICKS_FOR_YOU
    
    @State var viewModel: RestaurantViewModel
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    let products: [Product] = [
        .init(image: "burguer1", title: "Cheese-burger menu", subtitle: "Cheese-burger, big fries, coca-cola", price: "$8,99"),
        .init(image: "burguer1", title: "Chicken-burger", subtitle: "Chicken-burger, big fries, coca-cola", price: "$8,99"),
        .init(image: "burguer1", title: "Cheese-burger menu", subtitle: "Cheese-burger, big fries, coca-cola", price: "$8,99"),
        .init(image: "burguer1", title: "Cheese-burger menu", subtitle: "Cheese-burger, big fries, coca-cola", price: "$8,99"),
        .init(image: "burguer1", title: "Cheese-burger menu", subtitle: "Cheese-burger, big fries, coca-cola", price: "$8,99")

    ]
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack {
                    Header(headerProps: HeaderProps(iconLeftOne: "heart", iconLeftTwo: "magnifyingglass", actionRight: {
                        goBack()
                    }))
                    .padding(.horizontal)
                    
                    cardAboutRestaurant

                    filter

                    listProducts
                    Spacer()
                }
            }
//            .onAppear {
//                guard let id = restaurantID else { return }
//                viewModel.loadRestaurantDetails(id: id)
//            }
            .task {
                guard let id = restaurantID else { return }
                await viewModel.loadRestaurantDetails(id: id)
            }
            .padding(.bottom)

        }
        .toolbarVisibility(.hidden, for: .navigationBar)

    }
}

// See, if I can put the extension in another files
    extension RestaurantDetails {
        private var listProducts: some View {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Picks for you")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.textPrimary)
                        Image(systemName: "flame.fill")
                            .foregroundStyle(.yellow)
                    }
                    
                    Text("Trending items we think you love")
                        .font(.footnote)
                        .fontWeight(.regular)
                        .foregroundStyle(.textSecondary.opacity(0.5))
                    
                    // montar as colunas de produtos toda a tela é envolta do scrollView
                    LazyVGrid(columns: columns, spacing: 18) {
                        ForEach(viewModel.products) { item in
                            CardItem(
                                nameFood: item.title,
                                completementFood: item.subtitle,
                                priceFood: item.price,
                                imageUrl: item.imageUrl,
                                navigateTo: { AnyView(ProductDetail(productID: item.id, viewModel: ProductViewModel())) }
                            )
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 100)
                }
                .padding(.horizontal)

            }
         
        
        private var cardAboutRestaurant: some View {
         
            ZStack {
                if let restaurant = viewModel.restaurant {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color("White"))
                        .frame(height: 150)
                        .frame(maxWidth: .infinity)
                        .shadow(color: Color("Gray"), radius: 2, y: 8)
                
                VStack {
                    HStack() {
                        ImageLoader(imageUrl: restaurant.imageUrl)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .frame(width: 100, height: 90)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Fast Food company")
                                .font(.system(size: 8, weight: .regular, design: .default))
                                .foregroundStyle(.gray.opacity(0.5))
                            Text(restaurant.name)
                                .font(.headline)
                                .foregroundStyle(.textPrimary)
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundStyle(.gray.opacity(0.5))
                                    .font(.system(size: 16, weight: .regular, design: .default))
                                Text("\(restaurant.deliveryTimeMin)-\(restaurant.deliveryTimeMax) mins")
                                    .font(.footnote)
                                    .foregroundStyle(.gray.opacity(0.5))
                            }
                        }
                        .padding(.leading, 8)
                        
                        Spacer()
                        
                        VStack {
                            
                            HStack {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 8, weight: .regular, design: .default))
                                    .foregroundStyle(.yellow)
                                
                                Text(String("\(restaurant.rating)"))
                                    .foregroundStyle(.white)
                                    .font(.system(size: 8, weight: .regular, design: .default))
                                
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                            .background(Color("Black"))
                            .clipShape(Capsule())
                            .offset(y: -10)
                            
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .regular, design: .default))
                                    .foregroundStyle(.white)
                                    .frame(width: 40, height: 40)
                                    .background(Color("Tertiary"))
                                    .clipShape(Circle())
                                    .offset(y: 15)
                                
                            }
                        }
                    }
                    
                    HStack {
                        Image(systemName: "truck.box")
                            .foregroundStyle(Color("Tertiary"))
                            .font(.system(size: 12, weight: .regular, design: .default))
                        Text("Get your first 4 delivered free")
                            .font(.caption)
                            .foregroundStyle(Color("Tertiary"))
                    }
                    .padding(.vertical, 8)
                    .padding(.leading, 14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("Gray").opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.bottom)
                    
                    
                }
                .padding()
                .padding(.top)
                .frame(height: 90)
                    
                }
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 8)
            .padding(.top)
            
        }
        
        private var filter: some View {
            HStack {
                Button {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        showFilter.toggle()
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.system(size: 24, weight: .regular, design: .default))
                        .foregroundStyle(showFilter ? .white : .gray.opacity(0.4))
                        .frame(width: 50, height: 50)
                        .background(showFilter ? .black : .white.opacity(0))
                        .clipShape(Circle())
                        .overlay {
                            if !showFilter {
                                Circle()
                                    .stroke(.gray.opacity(0.4), lineWidth: 2)
                            }
                        }
                        .scaleEffect(showFilter ? 1.05 : 1)
                        .animation(
                                .spring(response: 0.3, dampingFraction: 0.7),
                                value: showFilter
                            )
                }
                
                if showFilter {
                    HStack {
                        // Turn a generic view
                        Text("Picks for you")
                            .font(.headline)
                            .foregroundStyle(filterSelected == FILTER_SELECTED.PICKS_FOR_YOU ? .white : Color("Black700").opacity(0.2))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 8)
                            .background(
                                Capsule()
                                    .fill(filterSelected == FILTER_SELECTED.PICKS_FOR_YOU ? Color("Primary") : Color("White").opacity(0))
                            )
                            .overlay {
                                Capsule()
                                    .stroke(
                                        filterSelected == .PICKS_FOR_YOU
                                        ? Color("Primary")
                                        : Color("Black700").opacity(0.2),
                                        lineWidth: 2
                                    )

                            }
                        
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    filterSelected = .PICKS_FOR_YOU
                                }
                            }
                        Text("New in")
                            .font(.headline)
                            .foregroundStyle(filterSelected == FILTER_SELECTED.NEW_IN ? .white : Color("Black700").opacity(0.2))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 8)
                            .background(
                                Capsule()
                                    .fill(filterSelected == FILTER_SELECTED.NEW_IN ? Color("Primary") : Color("White").opacity(0))
                            )
                            .overlay {
                                Capsule()
                                    .stroke(
                                        filterSelected == .NEW_IN
                                        ? Color("Primary")
                                        : Color("Black700").opacity(0.2),
                                        lineWidth: 2
                                    )

                            }
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    filterSelected = .NEW_IN
                                }
                            }
                        
                        Text("Popular")
                            .font(.headline)
                            .foregroundStyle(filterSelected == FILTER_SELECTED.POPULAR ? .white : Color("Black700").opacity(0.2))

                            .padding(.vertical, 12)
                            .padding(.horizontal, 8)
                            .background(
                                Capsule()
                                    .fill(filterSelected == FILTER_SELECTED.POPULAR ? Color("Primary") : Color("White").opacity(0))
                            )
                            .overlay {
                                Capsule()
                                    .stroke(
                                        filterSelected == .POPULAR
                                        ? Color("Primary")
                                        : Color("Black700").opacity(0.2),
                                        lineWidth: 2
                                    )

                            }
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    filterSelected = .POPULAR
                                }
                            }
                        
                    }
                }
               

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            .padding(.bottom, 8)
        }
        
        
    }



#Preview {
    RestaurantDetails(
        restaurantID: "956c8910-d731-465c-b567-c1c4b5c60419",
        viewModel: RestaurantViewModel(service: MockRestaurantService()),
    )
}

