//
//  SettingsView.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 11/05/26.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            ScrollView {
                VStack {
                    HStack {
                        HStack {
                            Image(systemName: "person")
                                .padding()
                                .background(Color("White"))
                                .shadow(radius: 4, x: 0.7, y: 0.7)
                                .clipShape(Circle())
                            
                            Text("Profile")
                        }
                        
                        Spacer()
                        
                        Image(systemName: "bell")
                            .padding()
                            .background(Color("White"))
                            .shadow(radius: 4, x: 0.7, y: 0.7)
                            .clipShape(Circle())
                  

                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Circle()
                            .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading) {
                            Text("Thiago Lourenço")
                                .font(.headline)
                                .foregroundStyle(Color("Black"))
                            Text("@ 012 Londor, New York")
                        }
                        
                        Spacer()
                        
                        Image(systemName: "square.and.pencil")
                            .font(Font.system(size: 20))
                            .foregroundStyle(Color("TextSecondary").opacity(0.4))
                    }
                    .padding(.vertical)
                    .padding(.horizontal)
                    .background(Color("White"))
                    .shadow(color: Color("Gray"), radius: 4, x: 0, y: 2)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal, 18)
                    .padding(.top)
                    
                    VStack {
                        settingsSection(title: "Settings", items: [
                            .init(icon: "star", title: "Rewards", trailing: "0 points"),
                            .init(icon: "bag", title: "Your orders", trailingIcon: "chevron.right"),
                            .init(icon: "banknote", title: "Balance", trailing: "$0,00"),
                            .init(icon: "ticket", title: "Vouchers", trailingIcon: "chevron.right"),
                            .init(icon: "tag", title: "Fresko Pro", trailingIcon: "chevron.right")
                        ])
                        
                        settingsSection(title: "Settings", items: [
                            .init(icon: "questionmark.circle", title: "Get Help", trailingIcon: "chevron.right"),
                            .init(icon: "info.circle", title: "About App", trailingIcon: "chevron.right"),
                        ])
                    }


                    Spacer()

                }
            }
         
          
        }
    }
    
    func settingsSection(title: String, items: [SettingItem]) -> some View {
      

        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.textPrimary)
                .fontWeight(.bold)
            
            VStack(spacing: 14) {
                ForEach(items) { item in
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: item.icon)
                                .foregroundStyle(Color("TextSecondary").opacity(0.4))
                                .padding(8)
                                .background(Color("White"))
                                .shadow(radius: 4, x: 0.7, y: 0.7)
                                .clipShape(Circle())

                            Text(item.title)
                                .font(.callout)
                                .foregroundStyle(Color("TextSecondary"))

                            Spacer()

                            if let trailing = item.trailing {
                                Text(trailing)
                                    .font(.caption)
                                    .foregroundStyle(Color("TextSecondary").opacity(0.3))
                            }

                            if let trailingIcon = item.trailingIcon {
                                Image(systemName: trailingIcon)
                                    .font(.caption)
                                    .foregroundStyle(Color("TextSecondary").opacity(0.3))
                            }
                        }
                    }
                    

                
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color("Gray"))
            .clipShape(RoundedRectangle(cornerRadius: 8))
           
            
        }
        .padding(8)
        .background(Color("White"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding()
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 4)
    }
}

#Preview {
    SettingsView()
}
