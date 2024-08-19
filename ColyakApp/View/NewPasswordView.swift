//
//  NewPasswordView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI
import PopupView

struct NewPasswordView: View {
    @ObservedObject var vm : ChangePasswordViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var passwordRepeat:String = ""
    @State var passwordControl = false

    var body: some View {
        NavigationView{
            VStack{
                VStack {
                    ZStack {
                        HStack {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                                vm.newPassword = ""
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
                
                
                VStack{
                    Text("Yeni şifrenizi belirleyin.")
                        .multilineTextAlignment(.center)
                        .padding(.top, 35)
                        .padding(.bottom,35)
                    
                    VStack(spacing:30){
                        HStack {
                            Image(systemName: "lock")
                                .resizable()
                                .frame(width: 15.23, height: 18.50)
                                .foregroundColor(.gray)
                                .padding(.leading, 15)
                            
                            SecureField("Şifre", text: $vm.newPassword)
                                .padding(.leading,7)
                                .font(Font.custom("Poppins", size: 14))
                                .lineSpacing(18)
                            .foregroundColor(Color(red: 0.68, green: 0.64, blue: 0.65))
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.80, height: 60)
                        .background(Color(red: 0.97, green: 0.97, blue: 0.97))
                        .cornerRadius(16)
                        
                        
                        HStack {
                            Image(systemName: "lock")
                                .resizable()
                                .frame(width: 15.23, height: 18.50)
                                .foregroundColor(.gray)
                                .padding(.leading, 15)
                            
                            SecureField("Şifre Tekrar", text: $passwordRepeat)
                                .padding(.leading,7)
                                .font(Font.custom("Poppins", size: 14))
                                .lineSpacing(18)
                            .foregroundColor(Color(red: 0.68, green: 0.64, blue: 0.65))
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.80, height: 60)
                        .background(Color(red: 0.97, green: 0.97, blue: 0.97))
                        .cornerRadius(16)
                    }
                    
                    HStack{
                       Button {
                           hideKeyboard()
                           if vm.newPassword != passwordRepeat {
                            
                               passwordControl = true
                           } else {
                               vm.changePasswordId(changepassId: vm.emailVerificationCode)
                           }
                        } label: {
                            Text("Şifreyi Değiştir")
                                .font(.system(size: 15))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 65)
                    .background(Color(red: 1, green: 0.48, blue: 0.22))
                    .cornerRadius(16)
                    .padding(.top,25)
                    .shadow(
                        color: Color(red: 0.58, green: 0.68, blue: 1, opacity: 0.30), radius: 22, y: 10)
                    Spacer()
                }
                
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .popup(isPresented: $vm.showingPopup) {
            VStack {
                PopupView(customize: $vm.custom)
                    .padding(.top)
                    if vm.passwordChangeTrue{
                        Text("Şifreniz başarıyla değiştirildi.")
                            .font(.title3)
                            .padding(.horizontal)
                            .fontWeight(.heavy)
                            .padding(.top, 35)
                            .multilineTextAlignment(.center)
                    } else {
                        Text("Şifrenizi değiştirme işlemi başarısız oldu.")
                            .font(.title3)
                            .fontWeight(.heavy)
                            .padding(.horizontal)
                            .padding(.top, 35)
                            .multilineTextAlignment(.center)
                        
                        Text("Tekrar deneyin.")
                            .font(.system(size: 17))
                            .padding(.top,2)
                    }
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height / 2)
            .background(.white)
            .cornerRadius(30.0)
            .onTapGesture {
                if vm.passwordChangeTrue{
                    presentationMode.wrappedValue.dismiss()
                    vm.newPassword = ""
                    vm.custom = false
                    vm.passwordChangeTrue = false
                    vm.showingPopup = false
                    vm.isPasswordChanged = false
                    vm.wrongEmail = false
                }
            }
        } customize: {
            $0.type(.default)
                .position(.center)
                .animation(.bouncy)
                .closeOnTapOutside(vm.passwordChangeTrue ? false : true)
                .backgroundColor(.black.opacity(0.75))
                .closeOnTap(true)
        }
        .popup(isPresented: $passwordControl) {
            VStack{
                PopupView(customize: $vm.custom)
                    .padding(.top)
                Text("Şifreleriniz Uyuşmuyor.")
                    .font(.title3)
                    .fontWeight(.heavy)
                    .padding(.top,35)
                Text("Tekrar deneyin.")
                    .font(.system(size: 17))
                    .padding(.top,2)
              
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height / 2)
            .background(.white)
            .cornerRadius(30.0)
            .onTapGesture {
                passwordControl = false
                print(passwordControl)
            }
        }customize: {
            $0
                .type(.default)
                .position(.center)
                .animation(.bouncy)
                .closeOnTapOutside(false)
                .backgroundColor(.black.opacity(0.75))
                .closeOnTap(true)
        }
    }
}

#Preview {
    NewPasswordView(vm: ChangePasswordViewModel())
}
