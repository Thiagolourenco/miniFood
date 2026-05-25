//
//  Login.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 18/05/26.
//

import SwiftUI

struct Login: View {
    var body: some View {
        NavigationStack {
            ZStack {
                
                Rectangle()
                    .fill(.black)
                    .frame(height: .infinity)

                LinearGradient(
                    colors: [
                            .clear,
                            Color.white.opacity(1),
                            Color.white.opacity(1),
                            Color.white.opacity(1),
                            Color.white.opacity(1),
                            Color.white


                        ],
                      startPoint: .top,
                      endPoint: .bottom
                  )
                    .blur(radius: 16)
                    .scaleEffect(1.4)
                    .frame(height: 300)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                
                VStack {
                    Spacer()

                    VStack {
                        Text("Welcome to ")
                            .font(.title)
                            .overlay {
                                Text("Fresko")
                                    .font(.title)
                                    .offset(x: 114)
                            }
                        
                            .padding(.trailing, 70)
                            .padding(.bottom)
                    
                        Button {
                            
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "apple.logo")
                                    .foregroundStyle(Color("White"))

                                Text("Continue with in Apple")
                                    .foregroundStyle(Color("White"))
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .background(Capsule().fill(.black))
                            .padding(.horizontal, 20)
                        }
                     
                        
                        HStack {
                            Button {
                                
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "safari")
                                        .foregroundStyle(Color("TextPrimary"))

                                    Text("Continue in Google")
                                        .foregroundStyle(Color("TextPrimary"))
                                        .font(.footnote)
                                }
                                .padding(18)
                                .background(Capsule().fill(Color("Gray")))

                            }
                          
                            
                            NavigationLink {
                              ContinueWithEmail()
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "envelope")
                                        .foregroundStyle(Color("TextPrimary"))

                                    Text("Continue in Email")
                                        .foregroundStyle(Color("TextPrimary"))
                                        .font(.footnote)

                                }
                                .padding(18)
                                .background(Capsule().fill(Color("Gray")))
                            
                            }
                        }
                        .padding(.top, 2)
                        
                        Text("By signing up you agree to our terms of service and pricary policy")
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 250)
                            .font(.system(size: 12))
                            .padding(.top, 12)
                    }
                    .padding(.top)
                    .background(Color("White"))
                    
                }
            }
            .ignoresSafeArea(edges: .top)
            .toolbarVisibility(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    Login()
}
