//
//  MealView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

struct MealView: View {
    @StateObject var foodList = MealViewModel()
    var mealSelectionArray : Array = [
        ["Öğün","cup.and.saucer.fill","200 / 650"]]
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "fork.knife.circle.fill")
                    .resizable()
                    .foregroundColor(.orange)
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 1)
                
                Text("Beslenme")
                    .font(.system(size: 24))
                    .fontWeight(.heavy)
                Spacer()
            }
            .padding(.leading,25)

            NavigationView{
                VStack{
                    ForEach(mealSelectionArray,id: \.self){ item in
                        NavigationLink(destination:
                            MealListView(mealViewModel: foodList)
                            .padding(.top,10)
                        ){
                            MealSelectionDesignView(title: item[0], iconName: item[1], value: item[2])
                        }
                    }
                    Spacer()
                }
                .padding(.top)
            }
            .frame(minWidth: 0,maxWidth: .infinity,minHeight: 0,maxHeight: .infinity)
        }
    }
}
#Preview {
    MealView()
}
