//
//  ChangePasswordView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

struct ChangePasswordView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var vm = ChangePasswordViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    ZStack {
                        HStack {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .frame(width: 10, height: 20)
                                    .foregroundColor(.black)
                                    .padding(.horizontal)
                            })
                            Spacer()
                        }
                        
                        Text("Şifremi Unuttum")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.black)
                    }
                } // NavigationTitle and Back Button
                .padding(.top)
                .frame(width: UIScreen.main.bounds.width)
                
                VStack {
                    HStack {
                        Image(systemName: "envelope")
                            .resizable()
                            .frame(width: 20, height: 17)
                            .foregroundColor(.gray)
                            .padding(.leading, 15)
                        
                        TextField("Mail adresinizi girin", text: $vm.emaill)
                            .padding(.leading, 5)
                            .font(Font.custom("Poppins", size: 14))
                            .foregroundColor(Color(red: 0.68, green: 0.64, blue: 0.65))
                          
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.80, height: 60)
                    .background(Color(red: 0.97, green: 0.97, blue: 0.97))
                    .cornerRadius(16)
                    .padding(.top, 30)
                    
                    HStack {
                        Button(action: {
                            hideKeyboard()
                            vm.changePassword(byEmail: vm.emaill)
                            vm.emaill = ""
                            vm.emailVerificationCode = ""
                        }) {
                            Text("Gönder")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 63)
                    .background(Color(red: 1, green: 0.48, blue: 0.22))
                    .cornerRadius(16)
                    .padding(.top, 25)
                    .shadow(color: Color(red: 0.58, green: 0.68, blue: 1).opacity(0.30), radius: 22, y: 10)
                    
                    Spacer()
                    
                   NavigationLink(
                    destination: NewPasswordView(vm: vm),
                        isActive: $vm.isPasswordChanged,
                        label: { EmptyView() }
                    )
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $vm.wrongEmail) {
            Alert(title: Text("Email Bulunamadı!"), message: Text("E-posta adresiniz bulunamadı. Lütfen kontrol edip tekrar deneyiniz."), dismissButton: .default(Text("Tamam")))
               }
    }
}

#Preview {
    ChangePasswordView()
}
