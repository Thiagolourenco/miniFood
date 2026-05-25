//
//  ContinueWithEmail.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 19/05/26.
//

import SwiftUI

struct ContinueWithEmail: View {
    @Environment(\.dismiss) private var dismiss
    @State private var debounceTask: Task<Void, Never>?
    @State private var showPassword: Bool = false
    @State private var showPasswordConfirm: Bool = false
    
    @State private var viewModel: ContinueWithEmailViewModel = ContinueWithEmailViewModel(service: ContinueWithEmailService())
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack {
                
                Header(headerProps: HeaderProps(actionRight: {
                   dismiss()
                }))
                
                Text("Continue with Email")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.textPrimary)
                
                VStack(spacing: 18) {
                    TextField("Email", text: $viewModel.email)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("White"))
                        .textInputAutocapitalization(.never)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal)
                        .shadow(color: .gray.opacity(0.2) , radius: 2, x: 2, y: 3)
                        .onChange(of: viewModel.email) { _, newValue in
                            debounceTask?.cancel()
                            
                            debounceTask = Task {
                                try? await Task.sleep(for: .milliseconds(700))
                                
                                guard !Task.isCancelled else { return }
                                
                                try? await viewModel.validEmail()
                            }
                        }
                    
                    
                    if !viewModel.userNotRegistered {
                        TextField("name", text: $viewModel.name)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("White"))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding(.horizontal)
                            .shadow(color: .gray.opacity(0.2) , radius: 2, x: 2, y: 3)
                        
                        HStack {
                            if showPassword {
                                TextField("Password", text: $viewModel.password)
                            } else {
                                SecureField("Password", text: $viewModel.password)
                            }
                            
                            Image(systemName: showPassword ? "eye" : "eye.slash")
                                .foregroundStyle(.black700.opacity(0.4))
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        showPassword.toggle()
                                    }
                                }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("White"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        viewModel.errorMessage != nil
                                            ? Color("Error").opacity(0.3)
                                            : Color.clear,
                                        style: StrokeStyle(lineWidth: 1)
                                    )
                        )
                        .padding(.horizontal)
                        .shadow(color: .gray.opacity(0.2) , radius: 2, x: 2, y: 3)
                        
                        HStack {
                            if showPasswordConfirm {
                                TextField("Password", text: $viewModel.confirmPassword)
                            } else {
                                SecureField("Password", text: $viewModel.confirmPassword)
                            }
                            
                            Image(systemName: showPasswordConfirm ? "eye" : "eye.slash")
                                .foregroundStyle(.black700.opacity(0.4))
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        showPasswordConfirm.toggle()
                                    }
                                }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("White"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        viewModel.errorMessage != nil
                                            ? Color("Error").opacity(0.3)
                                            : Color.clear,
                                        style: StrokeStyle(lineWidth: 1)
                                    )
                        )
                        .padding(.horizontal)
                        .shadow(color: .gray.opacity(0.2) , radius: 2, x: 2, y: 3)
                        
                        if viewModel.errorMessage != nil {
                            Text(viewModel.errorMessage ?? "")
                                .font(.caption2)
                                .foregroundStyle(Color("Error"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, -8)
                                .padding(.leading)
                            
                        }
                        
                    } else {
                        HStack {
                            if showPassword {
                                TextField("Password", text: $viewModel.password)
                            } else {
                                SecureField("Password", text: $viewModel.password)
                            }
                            
                            Image(systemName: showPassword ? "eye" : "eye.slash")
                                .foregroundStyle(.black700.opacity(0.4))
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        showPassword.toggle()
                                    }
                                }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("White"))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal)
                        .shadow(color: .gray.opacity(0.2) , radius: 2, x: 2, y: 3)


                        
                    }
                  
                }
                
                
                Button {
                    if !viewModel.userNotRegistered {
                        Task {
                            await viewModel.registerUser()
                        }
                    }
                    
                    Task {
                        await viewModel.login()
                    }
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("Black"))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding(.horizontal, 32)
                            .padding(.top)
                    } else {
                        Text(!viewModel.userNotRegistered ? "Register" : "Login")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("Black"))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding(.horizontal, 32)
                            .padding(.top)
                    }
                 
                }

                
                Spacer()
            }
            .navigationDestination(isPresented: $viewModel.shouldEnterTheApp) {
                MainTabView()
            }
            .toolbarVisibility(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    ContinueWithEmail()
}

