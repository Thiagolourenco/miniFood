//
//  Header.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 14/05/26.
//

import SwiftUI

/*
 Header -- Global
 -- Have custom icons in trailling and leading
 -- Text and headline is custom and it can show or no
 -- GoBack is a custom function,it come back screen
 -- the icon button that stay in right, it can come back to screen or navigte to new screen
 */
struct HeaderProps {
    let titleHeader: String?
    let titleHeadline: String?
    let iconRight: String
    let iconLeftOne: String?
    let iconLeftTwo: String
    let actionRight: () -> Void
    
    init(
        titleHeader: String? = nil,
        titleHeadline: String? = nil,
        iconRight: String = "arrow.left",
        iconLeftOne: String? = nil,
        iconLeftTwo: String = "person.crop.circle",
        actionRight: @escaping () -> Void = {}
    ) {
        self.titleHeader = titleHeader
        self.titleHeadline = titleHeadline
        self.iconRight = iconRight
        self.iconLeftOne = iconLeftOne
        self.iconLeftTwo = iconLeftTwo
        self.actionRight = actionRight
    }
}

struct Header: View {
    let headerProps: HeaderProps
    
    var body: some View {
        HStack {
            Button {
                headerProps.actionRight()
            } label: {
                Image(systemName: headerProps.iconRight)
                    .foregroundStyle(.textSecondary)
                    .font(.system(size: 14))
            }
            .frame(width: 40, height: 40)
            .background(Color("White"))
            .clipShape(Circle())
            .shadow(color: Color("Border") ,radius: 6, y: 6)
            
            if headerProps.titleHeader != nil {
                VStack(alignment: .leading) {
                    Text(headerProps.titleHeadline ?? "")
                        .foregroundStyle(Color("Black700"))
                        .font(.caption)
                        .fontWeight(.regular)
                 
                    Text(headerProps.titleHeader ?? "")
                        .foregroundStyle(.textPrimary)
                        .font(.callout)
                        .fontWeight(.medium)
                        .padding(.bottom, headerProps.titleHeadline == nil ? 12 : 0)
                    
                }
            }
            
            Spacer()
            
            HStack {
                if headerProps.iconLeftOne != nil {
                    Button {
                        
                    } label: {
                        Image(systemName: headerProps.iconLeftOne ?? "")
                            .foregroundStyle(.textSecondary)
                            .font(.system(size: 14))
                    }
                    .frame(width: 40, height: 40)
                    .background(Color("White"))
                    .clipShape(Circle())
                    .shadow(color: Color("Border") ,radius: 6, y: 6)
                    
                }
               
                Button {
                    
                } label: {
                    Image(systemName: headerProps.iconLeftTwo)
                        .foregroundStyle(.textSecondary)
                        .font(.system(size: 14))
                }
                .frame(width: 40, height: 40)
                .background(Color("White"))
                .clipShape(Circle())
                .shadow(color: Color("Border") ,radius: 6, y: 6)
            }
        }
        .padding(.horizontal, 8)

    }
}

#Preview {
    Header(headerProps:HeaderProps(titleHeader: "78 Street, Bangladesh") )
}
