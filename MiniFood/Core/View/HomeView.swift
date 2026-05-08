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
                    Spacer()
                    
                    Text("Home")
                }
                .navigationTitle("What's Your Graving Today?")
                .toolbarVisibility(.hidden, for: .navigationBar)
                
            }
        }
        
       
    }
}

extension HomeView {
    private var header: some View {
        VStack {
            headerActions
            
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
    
    private var headerActions: some View {
        HStack(spacing: 8) {
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "envelope")
                        .foregroundStyle(.textSecondary)
                        .font(.system(size: 14))
                }
                .frame(width: 40, height: 40)
                .background(Color("White"))
                .clipShape(Circle())
                .shadow(color: Color("Border") ,radius: 6, y: 6)
                
                
                VStack(alignment: .leading) {
                    Text("Delivery to")
                        .foregroundStyle(Color("Black700"))
                        .font(.caption)
                        .fontWeight(.regular)
                    Text("78 Street, Bangladash")
                        .foregroundStyle(.textPrimary)
                        .font(.callout)
                        .fontWeight(.medium)
                    
                }
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "bell")
                    .foregroundStyle(.textSecondary)
                    .font(.system(size: 14))
                
            }
            .frame(width: 40, height: 40)
            .background(Color("White"))
            .clipShape(Circle())
            .shadow(color: Color("Border") ,radius: 6, y: 6)
            
            
            Button {
                
            } label: {
                Image(systemName: "basket")
                    .foregroundStyle(.textSecondary)
                    .font(.system(size: 14))
                
            }
            .frame(width: 40, height: 40)
            .background(Color("White"))
            .clipShape(Circle())
            .shadow(color: Color("Border") ,radius: 6, y: 6)
            
        }
        .padding(.horizontal)
    }
}
#Preview {
    HomeView()
}
