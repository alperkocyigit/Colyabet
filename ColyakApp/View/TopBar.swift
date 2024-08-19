//
//  TopBar.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

struct TopBar: View {
    @State var width = UIScreen.main.bounds.width
    @Binding var x : CGFloat
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: {
                        withAnimation(){
                            x = 0
                        }
                    }, label: {
                        Image(systemName: "list.dash")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                            .padding()
                    })
                    Spacer()
                }
                HStack(spacing:0){
                    Image("topBar")
                        .resizable()
                        .frame(width: 50,height:50)
                    Text("Colyabet")
                        .font(.title3)
                        .foregroundColor(.black)
                        .fontWeight(.heavy)
                }
                .offset(x:-10)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color(red: 1, green: 0.48, blue: 0.22))
        }
        Spacer()
    }
}

#Preview {
    TopBar(x: .constant(0))
}
