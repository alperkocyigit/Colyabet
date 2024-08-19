//
//  MembershipOTP.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI
import PopupView

struct MembershipOTP: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var vm = VerificationViewModel()
    @ObservedObject var registerViewModel : RegisterViewModel
    @State var showingPopup = false
    @State var otpFields: [String] = Array(repeating: "", count: 6)
    @State private var secondsLeft = 10
    
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
                        
                        Text("Üyelik Onay Kodu")
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
                        VerifyCodeView(otpFields: $otpFields, isCodeCorrect: $vm.isCodeCorrect, isCodeChecked: $vm.isCodeChecked)
                    }
                    .padding(.top, 35)
                    
                    
                    VStack {
                        Button(action: {
                            vm.oneTimeCode = otpFields.joined()
                            vm.VerificationUser(verificationId: registerViewModel.verificationId)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                if vm.isCodeChecked {
                                    showingPopup = vm.isCodeCorrect
                                }
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
        }
        .navigationBarBackButtonHidden(true)
        .popup(isPresented: $showingPopup) {
            VStack{
                PopupView(customize: .constant(true))
                    .padding(.top)
                Text("Mail adresiniz doğrulandı.")
                    .font(.title3)
                    .fontWeight(.heavy)
                    .padding(.top,35)
                Text("Giriş ekranına gidiniz.")
                    .font(.system(size: 17))
                    .padding(.top,2)
            
                HStack{
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Git")
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                  
                }
                .frame(width: UIScreen.main.bounds.width * 0.5, height: 45)
                .background(Color(red: 1, green: 0.48, blue: 0.22))
                .cornerRadius(16)
                .shadow(
                    color: Color(red: 0.58, green: 0.68, blue: 1, opacity: 0.30), radius: 22, y: 10)
                   
            }
            .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height / 2)
            .background(.white)
            .cornerRadius(30.0)
         
        }customize: {
            $0
                .type(.default)
                .position(.center)
                .animation(.bouncy)
                .closeOnTapOutside(false)
                .backgroundColor(.black.opacity(0.75))
                .closeOnTap(false)
        }

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
    MembershipOTP(registerViewModel: RegisterViewModel())
}
