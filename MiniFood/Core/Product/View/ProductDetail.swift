//
//  ProductDetail.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 14/05/26.
//

import SwiftUI

struct ProductDetail: View {
    @State var productID: String
    @Environment(\.dismiss) private var dismiss
    @State private var isFooterVisible = false
    
    @State private var viewModel: ProductViewModel = ProductViewModel()

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            if let product = viewModel.product {
                
                VStack {
                    ScrollView(showsIndicators: false) {
                        
                        Header(headerProps: HeaderProps(iconLeftTwo: "heart", actionRight: {
                            dismiss()
                        }))
                        
                        VStack {
                            ImageLoader(imageUrl: product.imageUrl)
                                .clipShape(RoundedRectangle(cornerRadius: 8)
                                )
                                .frame(width: 300, height: 200)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(product.title)
                                        .font(.title3)
                                        .fontWeight(.medium)
                                        .foregroundStyle(Color("TextSecondary").opacity(0.4))
                                        .overlay {
                                            Text("Menu")
                                                .font(.title3)
                                                .fontWeight(.bold)
                                                .foregroundStyle(Color("TextPrimary"))
                                                .offset(x: 106)
                                            
                                        }
                                    Text(product.subtitle)
                                        .foregroundStyle(Color("TextSecondary").opacity(0.4))
                                        .font(.system(size: 8, weight: .regular, design: .default))
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Text(product.price)
                                        .font(.title2)
                                        .fontWeight(.medium)
                                        .overlay {
                                            Text("$")
                                                .font(.system(size: 12, weight: .regular, design: .default))
                                                .fontWeight(.regular)
                                                .foregroundStyle(Color("Primary"))
                                                .offset(x: -32, y: 4)
                                            
                                        }
                                    
                                    HStack(alignment: .center, spacing: 2) {
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 10, weight: .regular, design: .default))
                                            .foregroundStyle(.yellow)
                                        
                                        Text("\(product.rating)")
                                            .font(.system(size: 10, weight: .regular, design: .default))
                                        
                                            .fontWeight(.bold)
                                            .foregroundStyle(Color("TextPrimary"))
                                        
                                        Text("(\(product.reviewCount)+ Reviews)")
                                            .font(.system(size: 10, weight: .regular, design: .default))
                                            .foregroundStyle(Color("TextSecondary").opacity(0.4))
                                    }
                                }
                                
                            }
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity)
                            
                            HStack(spacing: 18) {
                                HStack {
                                    Image(systemName: "shippingbox")
                                        .font(.system(size: 14, weight: .regular, design: .default))
                                        .foregroundStyle(Color("TextPrimary"))
                                    
                                    Text("Free Delivery")
                                        .font(.system(size: 11, weight: .regular, design: .default))
                                        .foregroundStyle(Color("TextPrimary"))
                                }
                                
                                Rectangle()
                                    .fill(Color("Black700").opacity(0.2))
                                    .frame(width: 1, height: 16)
                                
                                HStack {
                                    
                                    Image(systemName: "watch.analog")
                                        .font(.system(size: 14, weight: .regular, design: .default))
                                        .foregroundStyle(Color("TextPrimary"))
                                    
                                    Text("Free Delivery")
                                        .font(.system(size: 11, weight: .regular, design: .default))
                                        .foregroundStyle(Color("TextPrimary"))
                                }
                                
                                Rectangle()
                                    .fill(Color("Black700").opacity(0.2))
                                    .frame(width: 1, height: 16)
                                
                                HStack {
                                    
                                    Image(systemName: "star")
                                        .font(.system(size: 14, weight: .regular, design: .default))
                                        .foregroundStyle(Color("TextPrimary"))
                                    
                                    Text("Free Delivery")
                                        .font(.system(size: 11, weight: .regular, design: .default))
                                        .foregroundStyle(Color("TextPrimary"))
                                }
                            }
                            .padding(.top, 16)
                            
                            VStack {
                                Text("Try these")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color("TextSecondary").opacity(0.4))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .overlay {
                                        Text("quick choices")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundStyle(Color("TextPrimary"))
                                            .offset(x: -40)
                                        
                                    }
                                    .padding(.leading)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        // Virar Component Unico
                                        Text("Coca-cola")
                                            .foregroundStyle(Color("White"))
                                            .padding(.horizontal, 32)
                                            .padding(.vertical, 12)
                                            .background(Capsule().fill(Color("Black")))
                                        
                                        // Virar Extension de cardStyle
                                        Text("Fanta")
                                            .foregroundStyle(Color("TextSecondary"))
                                            .padding(.horizontal, 32)
                                            .padding(.vertical, 12)
                                            .background(Capsule().fill(Color("Background")).stroke(Color("TextSecondary").opacity(0.2), style: StrokeStyle(lineWidth: 1)))
                                        // Virar Extension de cardStyle
                                        
                                        Text("Sprite")
                                            .foregroundStyle(Color("TextSecondary"))
                                            .padding(.horizontal, 32)
                                            .padding(.vertical, 12)
                                            .background(Capsule().fill(Color("Background")).stroke(Color("TextSecondary").opacity(0.2), style: StrokeStyle(lineWidth: 1)))
                                        // Virar Extension de cardStyle
                                        
                                        Text("Pepsi")
                                            .foregroundStyle(Color("TextSecondary"))
                                            .padding(.horizontal, 32)
                                            .padding(.vertical, 12)
                                            .background(Capsule().fill(Color("Background")).stroke(Color("TextSecondary").opacity(0.2), style: StrokeStyle(lineWidth: 1)))
                                        // Virar Extension de cardStyle
                                        
                                        Text("Guarana")
                                            .foregroundStyle(Color("TextSecondary"))
                                            .padding(.horizontal, 32)
                                            .padding(.vertical, 12)
                                            .background(Capsule().fill(Color("Background")).stroke(Color("TextSecondary").opacity(0.2), style: StrokeStyle(lineWidth: 1)))
                                        // Virar Extension de cardStyle
                                        
                                        
                                    }
                                    .padding(.horizontal)
                                }
                                .padding(.top, 8)
                                
                                HStack {
                                    Circle()
                                        .frame(width: 40, height: 40)
                                    VStack(alignment: .leading) {
                                        Text("Avarage delivery time")
                                        HStack {
                                            Image(systemName: "clock")
                                            Text("25-35 mins")
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "arrow.up.right")
                                            .foregroundStyle(Color("TextPrimary"))
                                            .frame(width: 50, height: 50)
                                            .background(Color("White"))
                                            .shadow(color: Color("TextSecondary"), radius: 6, x: 2, y: 4)
                                            .clipShape(Circle())
                                        
                                    }
                                    
                                }
                                .padding(.vertical,2)
                                .padding(.horizontal, 8)
                                .frame(maxWidth: .infinity)
                                .background(Capsule().fill(Color("Background")).stroke(Color("TextSecondary").opacity(0.2), style: StrokeStyle(lineWidth: 1)))
                                .padding(.horizontal)
                                .padding(.top, 8)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Description")
                                        .font(.title3)
                                        .bold()
                                    Text(product.description)
                                        .font(.system(size: 10, weight: .regular, design: .default))
                                        .foregroundStyle(Color("TextSecondary").opacity(0.4))
                                }
                                .padding(.top)
                                .padding(.horizontal)
                            }
                            .padding(.top)
                            
                            
                        }
                        .padding(.top)
                        
                        VStack {
                            HStack {
                                Text("Often order with")
                                    .font(.callout)
                                    .bold()
                                
                                Spacer()
                                
                                Text("View all >")
                                    .font(.system(size: 12, weight: .regular, design: .default))
                                    .foregroundStyle(Color("TextSecondary").opacity(0.4))
                            }
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(product.modifiers) { modifier in
//                                        ImageLoader(imageUrl: modifier.)
                                        RoundedRectangle(cornerRadius: 8)
                                            .frame(width: 100, height: 100)
                                    }
                                }
                                .padding(.top, 8)
                                .padding(.leading)
                            }
                        }
                        .padding(.top, 8)
                        
                        
                        Spacer()
                    }
                    
                    
                }
            }
        }
        .hidesTabBar()
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 18) {
                Button {
                    
                } label: {
                    Text("Add to Cart")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("TextPrimary"))
                        .frame(width: 160, height: 50)
                        .background(
                            Capsule()
                                .fill(Color("White"))
                                .shadow(color: Color("TextSecondary").opacity(0.4), radius: 0.4, x: 0.4, y: 0.4)
                        )
                }
                
                
                Button {
                    
                } label: {
                    Text("Order")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("White"))
                        .frame(width: 160, height: 50)
                        .background(
                            Capsule()
                                .fill(.black)
                        )
                    
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 12)
            .background(Color("Background"))
            .offset(y: isFooterVisible ? 0 : 80)
            .opacity(isFooterVisible ? 1 : 0)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6)) {
                isFooterVisible = true
            }
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        .task {
            await viewModel.getProduct(productID: productID)
        }
    }
}

#Preview {
    ProductDetail(productID: "bf2dc638-546e-424a-a9c1-73757755be09")
}
