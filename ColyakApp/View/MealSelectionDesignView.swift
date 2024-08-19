//
//  MealSelectionDesignView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

struct MealSelectionDesignView: View {
    var title:String
    var iconName:String
    var value:String
    
    var body: some View {
        VStack{
            HStack{
                ZStack{
                    MealCircleProgressView(progress: 0.2)
                        .frame(width:60,height:60)
                    Image(systemName: iconName)
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 30,height: 30)
                }
                VStack(spacing:8){
                    Text(title)
                        .padding(.leading,-15)
                        .font(.headline)
                        .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
                        .bold()
                    
                    Text(value)
                        .font(.caption)
                        .foregroundColor(Color(red: 0.38, green: 0.38, blue: 0.38))
                }
                .padding()
                Spacer()
                
                Image(systemName: "chevron.forward")
                    .resizable()
                    .frame(width: 15,height: 30)
                    .foregroundColor(.orange)
            }
            .padding(.horizontal,30)
           
        }
        .frame(width:UIScreen.main.bounds.width * 0.9,height: 80)
        .background(Color.white)
        .padding(.horizontal,8)
        .padding(.all, 1)
        .cornerRadius(30)
        .shadow(
            color: Color(red: 0.02, green: 0.02, blue: 0.06, opacity: 0.05), radius: 52.74, y: 3.52)
    }
}
#Preview {
    MealSelectionDesignView(title:"Kahvaltı", iconName: "cup.and.saucer.fill", value: "200/650")
}
