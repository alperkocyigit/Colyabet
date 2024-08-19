//
//  NutrificationProgressView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

struct NutritionProgressView: View {
    var title: String
    var progress: Double
    var goal: String
    
    var body: some View {
        VStack(alignment: .center) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.12))
                .padding(.bottom,8)
            ProgressView(value: progress)
                .frame(height: 6)
                .accentColor(Color(red: 1, green: 0.48, blue: 0.22))
            Text(goal)
                .font(.caption)
        }
    }
}
#Preview {
    NutritionProgressView(title: "", progress: 5.0, goal: "105")
}
