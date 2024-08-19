//
//  MealListView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

class SharedData: ObservableObject {
    static let shared = SharedData()
    @Published var totalCarbohydrates: String = "0"
}

struct MealListView: View {
    @StateObject var mealViewModel = MealViewModel()
    @ObservedObject var sharedData = SharedData.shared
    @State var isActive : Bool = false
    
 
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    HStack{
                        Rectangle()
                             .foregroundColor(.clear)
                             .frame(width: 5, height: 40)
                             .background(Color(red: 1, green: 0.48, blue: 0.22))
                             .cornerRadius(8.93)
                             .rotationEffect(.degrees(180))
                        HStack {
                            Text("Karbonhidrat")
                                .fontWeight(.semibold)
                        }
                        .padding(.leading)
                        Spacer()
                
                        Spacer()
                        HStack {
                            Text("\(sharedData.totalCarbohydrates) Gr")
                                .fontWeight(.semibold)
                        }
                        .padding(.trailing)
                        Rectangle()
                             .foregroundColor(.clear)
                             .frame(width: 5, height: 40)
                             .background(Color(red: 1, green: 0.48, blue: 0.22))
                             .cornerRadius(8.93)
                             .rotationEffect(.degrees(0))
                    }
                    Spacer()
                }
                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 0.98, blue: 0.95), Color(red: 1, green: 0.94, blue: 0.93)]), startPoint: .leading, endPoint: .trailing))
                .frame(width:UIScreen.main.bounds.width * 0.9, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                Spacer()
            }
            HStack {
                Text("Öğün")
                    .bold()
                    .font(.system(size: 24))
                Spacer()
            }
            .padding(.leading)
            .padding(.top,30)
            .frame(width: UIScreen.main.bounds.width)
            NavigationStack {
                ScrollView{
                    HStack{
                        VStack(spacing:20){
                            ForEach(mealViewModel.food, id:\.id) { item in
                                VStack(spacing:10) {
                                    HStack{
                                        VStack(spacing:10){
                                            HStack {
                                                Text("\(item.foodName ?? "")")
                                                    .font(.system(size: 18))
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
                                                    .lineLimit(1)
                                                Spacer()
                                                
                                                
                                            }
                                            HStack {
                                                Text("Karbonhidrat: \(item.carbonhydrate ?? 0) Gram")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(Color(red: 0.38, green: 0.38, blue: 0.38))
                                                Spacer()
                                                
                                            }
                                        }
                                        Spacer()
                                        Button {
                                            removeItem(item)
                                        } label: {
                                            Image(systemName: "trash")
                                                .font(.system(size: 20))
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .frame(width: UIScreen.main.bounds.width * 0.9,height: 80)
                                .background(.white)
                                .cornerRadius(12)
                                .shadow(
                                    color: Color(red: 0.02, green: 0.02, blue: 0.06, opacity: 0.05), radius: 52.74, y: 3.52
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                }
                .padding(.top)
                .background(.white)
                .scrollIndicators(.hidden)
                .frame(width: UIScreen.main.bounds.width)
                .overlay(alignment: .bottomTrailing) {
                    NavigationLink(destination: MealAddView(mealViewModel:mealViewModel)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 18)
                                .foregroundColor(Color(red: 1, green: 0.48, blue: 0.22))
                            
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.title2)
                                .bold()
                        }
                        .frame(width: 60, height: 60)
                    }
                    .padding(.trailing)
                }
            }
        }
        .onAppear {
            SharedData.shared.totalCarbohydrates = String(calculateTotalCarbohydrates())
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    func removeItem(_ item: Food) {
        mealViewModel.food.removeAll(where: { $0.id == item.id })
        sharedData.totalCarbohydrates = String(calculateTotalCarbohydrates())
       }
    func calculateTotalCarbohydrates() -> Int {
        var totalCarbohydrates = 0
        for item in mealViewModel.food {
            totalCarbohydrates += item.carbonhydrate ?? 0
        }
        return totalCarbohydrates
    }
}
#Preview {
    MealListView()
}
