//
//  MenuButtons.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

struct MenuButtons: View {
    var title:String
    var iconName:String
    
    var body: some View {
        HStack{
            ZStack {
                Image(systemName: iconName)
                    .foregroundColor(Color.black)
                    .font(.system(size: 25))
                   
                   
            }
            Text(title)
                .foregroundColor(.black)
                .fontWeight(.regular)
                .padding(.horizontal, 10)
            Spacer()
            ZStack {
                Image(systemName: "chevron.forward")
                    .foregroundColor(Color.black)
            }
        }
        .frame(height: 50)
    }
}

#Preview {
    MenuButtons(title: "User Details", iconName: "person")
}
