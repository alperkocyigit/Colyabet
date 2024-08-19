//
//  ChangePasswordOTP.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

struct ChangePasswordOTP: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isCodeCorrect: Bool = false
    @State var isCodeChecked: Bool = false
    @State var code: [String] = ["1", "2", "3", "4", "5", "6"]
    @State var otpFields: [String] = Array(repeating: "", count: 6)
    @State private var secondsLeft = 10
    @State var email: String = ""
    
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
                    
                } //NavigationTitle and Back Button
                .padding(.top)
                .frame(width: UIScreen.main.bounds.width)
                
                
                VStack {
                    Text("Mail adresine gelen kodu giriniz.")
                        .multilineTextAlignment(.center)
                        .padding(.top, 35)
                    
                    VStack {
                        VerifyCodeView(otpFields: $otpFields, isCodeCorrect: $isCodeCorrect, isCodeChecked: $isCodeChecked)
                    }
                    .padding(.top, 35)
                    
                    
                    VStack {
                       // NavigationLink(destination: NewPasswordView(), isActive: $isCodeCorrect) {
                           EmptyView()
                        }
                        
                        Button(action: {
                            // Kodu kontrol et
                            if otpFields == code {
                                isCodeCorrect = true
                            } else {
                                isCodeCorrect = false
                            }
                            isCodeChecked = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                isCodeChecked = false
                            }
                        }) {
                            Text("Gönder")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 63)
                        .background(Color(red: 1, green: 0.48, blue: 0.22))
                        .cornerRadius(16)
                        .padding(.top, 45)
                        .shadow(color: Color(red: 0.58, green: 0.68, blue: 1, opacity: 0.30), radius: 22, y: 10)
                        HStack {
                            Button{
                                secondsLeft = 10
                                Timer()
                            } label: {
                                Text("Kodu Tekrar Gönder(\(String(secondsLeft))sn)")
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    
                            }
                            .disabled(secondsLeft == 0 ? false : true)
                            
                            
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 63)
                        .background(secondsLeft == 0 ? Color(red: 1, green: 0.48, blue: 0.22) : .gray)
                        .cornerRadius(16)
                        .padding(.top, 25)
                        .shadow(
                            color: Color(red: 0.58, green: 0.68, blue: 1, opacity: 0.30), radius: 22, y: 10)
                        Spacer()
                    }
                    
                }
                Spacer()
            }
            .onAppear(perform: Timer)
            .navigationBarBackButtonHidden(true)
        }
        
    func Timer() {
        Foundation.Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if secondsLeft > 0 {
                secondsLeft -= 1
            } else {
                timer.invalidate()
            }
        }
    }
}

#Preview {
    ChangePasswordOTP()
}
