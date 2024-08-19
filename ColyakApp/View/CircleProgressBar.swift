//
//  CircleProgressBar.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

struct CircleProgressBar: View {
    var progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10.0)
                .opacity(0.3)
                .foregroundColor(Color.gray)
            
            Circle()
                .trim(from: 0.3, to: CGFloat(1.0))
                .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color(red: 1, green: 0.48, blue: 0.22))
                .rotationEffect(Angle(degrees:270))
                .animation(.linear)
        }
    }
}

#Preview {
    CircleProgressBar(progress: 0.1)
}

