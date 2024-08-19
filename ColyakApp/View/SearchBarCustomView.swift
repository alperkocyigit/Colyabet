//
//  SearchBarCustomView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

struct SearchBarCustomView: View {
    @Binding var searchText :String
    var body: some View {
        VStack{
            HStack {
                HStack{
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 20,height: 20)
                        .foregroundColor(.orange)
                        .background(Circle()
                            .foregroundColor(Color.orange.opacity(0.2))
                            .frame(width: 44,height: 44))
                        .padding(.trailing,15)
                    
                    TextField("Ara",text:$searchText)
                        .padding()
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                }
            }
        }
    }
}
#Preview {
    SearchBarCustomView(searchText: .constant(""))
}
