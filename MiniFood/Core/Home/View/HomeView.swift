//
//  HomeView.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 07/05/26.
//

import SwiftUI

struct HomeView: View {
    @State private var search: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                ScrollView {
                    
                
                    VStack {
                        header
                            .padding(.horizontal, 6)
                        
                        HStack(spacing: 12) {
                            TextField("Placeholder", text: $search)
                                .padding()
                                .frame(height: 50)
                                .background(Color("White"))
                                .clipShape(RoundedRectangle(cornerRadius: 32))
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "viewfinder")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color("Background"))
                            }
                            .frame(width: 50, height: 50)
                            .background(Color("Black"))
                            .clipShape(Circle())
                            
                        }
                        .padding(.horizontal, 16)
                        
                        ScrollView([.horizontal], showsIndicators: false,) {
                            HStack(spacing: 12) {
                                ForEach(0..<10) { _ in
                                    VStack {
                                        
                                        Circle()
                                            .frame(width: 50, height: 50)
                                        
                                        // Broke the line
                                        Text("Fast Food")
                                            .font(.caption)
                                    }
                                    .frame(maxWidth: 50)
                                }
                            }
                            .padding(.horizontal, 18)
                            
                        }
                        .padding(.top)
                        
                        
                        // Virar uma exestetion 
                        ScrollView([.horizontal], showsIndicators: false) {
                            HStack(spacing: 28) {
                                ForEach(0..<10) { _ in
                                    VStack() {
                                        
                                        // Virar a imagem em destaque do restaurante da semana
                                        RoundedRectangle(cornerRadius: 32)
                                            .fill(Color.yellow)
                                            .frame(width: 300, height: 200)
                                            .overlay(alignment: Alignment.topLeading) {
                                                HStack(alignment: .center) {
                                                    HStack {
                                                        Image(systemName: "clock.fill")
                                                            .tint(.black)
                                                            .foregroundStyle(.white)
                                                        Text("~35 min")
                                                            .font(.caption)
                                                            .fontWeight(.regular)
                                                            .foregroundStyle(.white)
                                                        
                                                        
                                                    }
                                                    .frame(width: 100, height: 32)
                                                    .background(Material.ultraThin)
                                                    .clipShape(RoundedRectangle(cornerRadius: 42))
                                                    .padding(.leading)
                                                    .padding(.top)
                                                    
                                                    Spacer()
                                                    
                                                    HStack {
                                                        Image(systemName: "truck.box")
                                                            .tint(.black)
                                                            .foregroundStyle(Color("TextPrimary").opacity(0.4))
                                                        
                                                        Text("~35 min")
                                                            .font(.caption)
                                                            .fontWeight(.regular)
                                                            .foregroundStyle(Color("TextPrimary").opacity(0.4))
                                                        
                                                        
                                                    }
                                                    .padding(.top)
                                                    .padding(.trailing)
                                                }
                                                
                                                
                                                
                                            }
                                        // Broke the line
                                        HStack {
                                            HStack {
                                                Text("McDonalds *")
                                                    .font(.subheadline)
                                                    .foregroundStyle(.textSecondary)
                                                Image(systemName: "flame.fill")
                                                    .foregroundStyle(.yellow)
                                            }
                                            
                                            Spacer()
                                            
                                            Text("New Open")
                                                .font(.caption)
                                                .foregroundStyle(Color("Tertiary"))
                                                .frame(width: 90, height: 28)
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 32)
                                                        .stroke(Color("Tertiary"), lineWidth: 1)
                                                }
                                            
                                            
                                            
                                        }
                                        .padding(.top, 2)
                                        .padding(.horizontal)
                                    }
                                    .frame(maxWidth: 300)
                                }
                            }
                            .padding(.horizontal, 18)
                            
                        }
                        .padding(.top)
                        
                        
                        // You lastest orders
                        HStack {
                            HStack(spacing: 0) {
                                Text("Your ")
                                    .foregroundStyle(Color("Black"))
                                
                                Text("Latest ")
                                    .foregroundStyle(.gray)
                                    .fontWeight(.regular)
                                
                                Text("Orders?")
                                    .foregroundStyle(Color("Black"))
                            }
                            .font(.system(size: 18, weight: .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            //                        .padding(.top)
                            
                            Text("View all >")
                                .font(.caption2)
                                .foregroundStyle(.gray)
                                .fontWeight(.regular)
                            
                            
                        }
                        .padding(.horizontal, 18)
                        .padding(.top)
                        
                        ScrollView([.horizontal], showsIndicators: false) {
                            HStack {
                                
                                ForEach(0..<10) { _ in
                                    ZStack() {
                                        RoundedRectangle(cornerRadius: 18)
                                            .fill(Color("White"))
                                            .frame(width: 300, height: 80)
                                            .shadow(color: Color("Gray"), radius: 9, y: 6)
                                        
                                        
                                        NavigationLink {
                                            RestaurantDetails()
                                        } label: {
                                            RoundedRectangle(cornerRadius: 18)
                                                .fill(Color("Primary"))
                                                .frame(width: 50, height: 50)
                                            
                                            VStack(alignment: .leading) {
                                                Text("Fast food category")
                                                    .font(.caption)
                                                    .fontWeight(.regular)
                                                    .foregroundStyle(.textSecondary.opacity(0.4))
                                                Text("Burger king")
                                                    .font(.callout)
                                                    .foregroundStyle(.textPrimary)
                                                HStack {
                                                    Image(systemName: "clock")
                                                        .font(.system(size: 11, weight: .regular, design: .default))
                                                        .foregroundStyle(.textSecondary.opacity(0.4))
                                                    Text("45-60 mins")
                                                        .font(.caption)
                                                        .fontWeight(.regular)
                                                        .foregroundStyle(.textSecondary.opacity(0.4))
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            HStack {
                                                Image(systemName: "star.fill")
                                                    .font(.system(size: 8, weight: .regular, design: .default))
                                                    .foregroundStyle(.yellow)
                                                
                                                Text("4.5")
                                                    .foregroundStyle(.white)
                                                    .font(.system(size: 8, weight: .regular, design: .default))
                                                
                                            }
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 4)
                                            .background(Color("Black"))
                                            .clipShape(Capsule())
                                            .offset(x: 10, y: -25)
                                        }
                                        .padding()
                                    }
                                    
                                }
                                
                            }
                            .padding(.horizontal, 28)

                            }
                            .frame(height: 100)
                        }
                    }
                  
                    Spacer()
                    
                }
                .navigationTitle("What's Your Graving Today?")
                .toolbarVisibility(.hidden, for: .navigationBar)
                
            }
        }
        
}

extension HomeView {
    private var header: some View {
        VStack {
            Header(headerProps: HeaderProps(
                titleHeader: "78 Street, Bangladash",
                titleHeadline: "Delivery to",
                iconRight: "envelope",
                iconLeftOne: "bell",
                iconLeftTwo: "basket"
            ))
            
            HStack(spacing: 0) {
                Text("What's ")
                    .foregroundStyle(Color("Black"))
                
                Text("Your Craving ")
                    .foregroundStyle(.gray)
                    .fontWeight(.regular)
                
                Text("Today?")
                    .foregroundStyle(Color("Black"))
            }
            .font(.system(size: 26, weight: .semibold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            .padding(.top)
        }
    }
}

#Preview {
    HomeView()
}

