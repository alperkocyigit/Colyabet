//
//  PopupView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

struct PopupView: View {
    @Binding var customize:Bool
    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .frame(width: 150,height: 150)
                    .foregroundColor(customize ? Color(red: 1, green: 0.48, blue: 0.22) : Color.red)
                Image(systemName: "shield.fill")
                    .resizable()
                    .frame(width: 40,height: 50)
                    .foregroundColor(.white)
                Image(systemName: customize ? "checkmark" : "xmark")
                    .resizable()
                    .frame(width: customize ? 15 : 18 ,height: customize ? 10 : 15)
                    .bold()
                    .foregroundColor( customize ? Color(red: 1, green: 0.48, blue: 0.22) : Color.red)
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.6 ,height: UIScreen.main.bounds.height / 4)
        .background(PopupViewBackground(customize: $customize))
    }
}

#Preview {
    PopupView(customize: .constant(false))
}
