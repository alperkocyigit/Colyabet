//
//  ProfileView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var loginViewModel = LoginViewModel()
    @State var userEmail: String = ""
    @State var userName : String = ""
    
    var body: some View {
        VStack(spacing:25){
            VStack {
                ZStack {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .frame(width: 12, height: 20)
                               
                                .foregroundColor(.black)
                                .padding(.horizontal)
                        })
                        Spacer()
                    }
                    
                    Text("Profil")
                        .font(.title)
                        .bold()
                        .foregroundColor(.black)
                      
                }
            }
            .frame(width: UIScreen.main.bounds.width)
            HStack {
                Text(userName)
                    .padding(.leading,5)
                    .font(Font.custom("Poppins", size: 14))
                    .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
                Spacer()
            }
            .padding(.leading)
            .frame(width: UIScreen.main.bounds.width * 0.90, height: 70)
            .background(Color(red: 0.97, green: 0.97, blue: 0.97))
            .cornerRadius(16)
            
            HStack {
                Text(userEmail)
                    .padding(.leading,5)
                    .font(Font.custom("Poppins", size: 14))
                    .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
                Spacer()
                Image(systemName: "envelope")
                    .resizable()
                    .frame(width: 20, height: 15)
                    .foregroundColor(.black)
                    .padding(.leading, 15)
            }
            .padding(.horizontal)
            .frame(width: UIScreen.main.bounds.width * 0.90, height: 70)
            .background(Color(red: 0.97, green: 0.97, blue: 0.97))
            .cornerRadius(16)
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            userEmail = loginViewModel.getEmailFromUserDefaults() ?? "No Email"
            userName = loginViewModel.getUsernameUserDefaults() ?? "No UserName"
        }
    }
}

#Preview {
    ProfileView()
}
