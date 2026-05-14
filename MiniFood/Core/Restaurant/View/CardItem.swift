//
//  CardItem.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 13/05/26.
//

import SwiftUI

struct CardItem: View {
    let nameFood: String
    let completementFood: String
    let priceFood: String
    
    var body: some View {
        VStack {
            // Image the food
            Rectangle()
                .frame(width: 100, height: 90)
            //
            
            Text(nameFood)
                .font(.system(size: 14, weight: .regular, design: .default))
                .fontWeight(.semibold)
                .padding(.vertical, 4)
            
            Text(completementFood)
                .font(.system(size: 6, weight: .regular, design: .default))
                .foregroundStyle(.textSecondary.opacity(0.3))
            
            Spacer()
            HStack(alignment: .bottom) {
                Text("$")
                    .font(.callout)
                    .foregroundStyle(Color("Primary"))
                Text(priceFood)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                        .background(Color("Tertiary"))
                        .clipShape(Circle())
                    
                }
            }
            .padding(.bottom, 8)
        }
        .padding(.top, 8)
        .padding(8)
        .frame(width: 160, height: 200)
        .background(Color("White"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black700.opacity(0.1), radius: 6, x: 2, y: -1)
    }
}

#Preview {
    CardItem(nameFood: "Cheese-buguesr", completementFood: "Cheese-burguer, fries, coca-cola/sprite/fanta", priceFood: "14.99")
}
