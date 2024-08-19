//
//  PopupViewBackground.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

struct PopupViewBackground: View {
    @State private var randomCircle:Int = 15
    @State private var isAnimating: Bool = false
    @Binding var customize: Bool
    
    // MARK: - FUNCTIONS
    
    // 1. RANDOM COORDINATE
    func randomCoordinate(max: CGFloat) -> CGFloat {
      return CGFloat.random(in: 0...max)
    }
    
    // 2. RANDOM SIZE
    func randomSize() -> CGFloat {
      return CGFloat(Int.random(in: 10...50))
    }
    
    // 3. RANDOM SCALE
    func randomScale() -> CGFloat {
      return CGFloat(Double.random(in: 0.1...1.0))
    }
    
    // 4. RANDOM SPEED
    func randomSpeed() -> Double {
        return Double.random(in: 1.0...2.0)
    }
    
    // 5. RANDOM DELAY
    func randomDelay() -> Double {
      return Double.random(in: 0...1)
    }
    
    // MARK: - BODY

    var body: some View {
      GeometryReader { geometry in
        ZStack {
          ForEach(0...randomCircle, id: \.self) { item in
            Circle()
                  .foregroundColor(customize ? Color(red: 1, green: 0.48, blue: 0.22) : Color.red)
              .frame(width: randomSize(), height: randomSize(), alignment: .center)
              .scaleEffect(isAnimating ? randomScale() : 1)
              .position(
                x: randomCoordinate(max: geometry.size.width),
                y: randomCoordinate(max: geometry.size.height)
              )
              .animation(
                Animation.interpolatingSpring(stiffness: 7.5, damping: 7.5)
                  .speed(randomSpeed())
              )
              .onAppear(perform: {
                isAnimating = true
              })
          } //: LOOP
        } //: ZSTACK
        .drawingGroup()
      } //: GEOMETRY
    }
}

#Preview {
    PopupViewBackground(customize: .constant(true))
}
