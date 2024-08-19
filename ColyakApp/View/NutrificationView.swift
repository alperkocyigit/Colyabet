//
//  NutrificationView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

struct NutrificationView: View {
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12.50)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 0.98, blue: 0.95), Color(red: 1, green: 0.94, blue: 0.93)]), startPoint: .leading, endPoint: .trailing))
                    .frame(width:UIScreen.main.bounds.width * 0.9,height: 370)
                    .overlay(
                        VStack(alignment: .center) {
                            HStack {
                                Rectangle()
                                     .foregroundColor(.clear)
                                     .frame(width: 6, height: 35)
                                     .background(Color(red: 1, green: 0.48, blue: 0.22))
                                     .cornerRadius(8.93)
                                     
                                Text("Özet")
                                    .foregroundColor(Color(red: 0.05, green: 0.09, blue: 0.16))
                                    .fontWeight(.semibold)
                                    .font(.headline)
                                Spacer()
                                Text("Detaylar")
                                    .foregroundColor(Color(red: 0.05, green: 0.09, blue: 0.16))
                                    .fontWeight(.semibold)
                                    .font(.headline)
                                Rectangle()
                                     .foregroundColor(.clear)
                                     .frame(width: 6, height: 35)
                                     .background(Color(red: 1, green: 0.48, blue: 0.22))
                                     .cornerRadius(8.93)
                            }
                           
                            .padding(.vertical, 10)
                        
                            HStack {
                                VStack(alignment: .center) {
                                    Text("1500")
                                        .font(.system(.title3))
                                        .foregroundColor(Color(red: 1, green: 0.48, blue: 0.22))
                                    Text("Alınan")
                                        .font(.system(.title3))
                                        .foregroundColor(Color(red: 1, green: 0.48, blue: 0.22))
                                }
                                
                                ZStack {
                                    CircleProgressBar(progress: 0.6) // Daire progress bar buraya eklendi
                                        .frame(width: 150, height: 150)
                                    
                                    VStack(alignment: .center) {
                                        Text("2115")
                                            .font(.system(.title2))
                                            .foregroundColor(Color(red: 1, green: 0.48, blue: 0.22))
                                        Text("Kalan")
                                            .font(.system(size: 16).weight(.heavy))
                                            .foregroundColor(Color(red: 1, green: 0.48, blue: 0.22))
                                    }
                                }
                                .frame(width: 175)
                                .padding(5)
                                
                                VStack(alignment: .center) {
                                    Text("2500")
                                        .font(.system(.title3))
                                        .foregroundColor(Color(red: 1, green: 0.48, blue: 0.22))
                                    Text("Hedef")
                                        .font(.system(.title3))
                                        .foregroundColor(Color(red: 1, green: 0.48, blue: 0.22))
                                }
                            }
                            .padding(.horizontal, 35)
                            .padding(.vertical, 10)
                            
                            
                            HStack(spacing: 10) {
                                NutritionProgressView(title: "Karbonhidrat", progress: 0.7, goal: "0 / 258 g")
                                NutritionProgressView(title: "Protein", progress: 0.7, goal: "0 / 103 g")
                                NutritionProgressView(title: "Yağ", progress: 0.5, goal: "0 / 68 g")
                            }
                            .padding()
                        }
                    )
                    .padding(.all, 1)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    
            }
            Spacer()
        }
        .padding(.horizontal,7)
    }
}

#Preview {
    NutrificationView()
}
