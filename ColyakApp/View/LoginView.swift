//
//  LoginView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: LoginViewModel
    var isValid : Bool {
        !viewModel.email.isEmpty && !viewModel.passwordd.isEmpty
    }
    @FocusState var focusState
    
    var body: some View {
        VStack {
            NavigationView {
                VStack(alignment: .center, spacing: 20) {
                    Image("login")
                        .resizable()
                        .imageScale(.medium)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                       
                    
                    Text("Hoşgeldiniz")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                        .multilineTextAlignment(.center)
                        .bold()
                        .padding(.top,25)
                        .padding()
                    
                    HStack {
                        Image(systemName: "envelope")
                            .resizable()
                            .frame(width: 20, height: 17)
                            .foregroundColor(.gray)
                            .padding(.leading, 15)
                            .tint(.black)
                        
                        TextField("E-posta", text: $viewModel.email)
                            .padding(.leading,5)
                            .font(Font.custom("Poppins", size: 14))
                            .foregroundColor(Color(red: 0.68, green: 0.64, blue: 0.65))
                            .keyboardType(.emailAddress)
                            .tint(.black)
                            .onSubmit {
                                focusState = true
                            }
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
                        
                        SecureField("Şifre", text: $viewModel.passwordd)
                            .padding(.leading,7)
                            .font(Font.custom("Poppins", size: 14))
                            .lineSpacing(18)
                            .foregroundColor(Color(red: 0.68, green: 0.64, blue: 0.65))
                            .tint(.black)
                            .focused($focusState)
                            .onSubmit {
                                viewModel.loginUser()
                            }
                        
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.80, height: 60)
                    .background(Color(red: 0.97, green: 0.97, blue: 0.97))
                    .cornerRadius(16)
                    
                    NavigationLink(destination: {
                        ChangePasswordView()
                    }, label: {
                        Text("Şifrenizi mi unuttunuz?")
                            .font(Font.custom("Poppins", size: 15).weight(.medium))
                            .lineSpacing(18)
                            .underline()
                            .foregroundColor(Color(red: 0.68, green: 0.64, blue: 0.65))
                    })
                    Button(action: {
                        viewModel.loginUser()
                    }, label: {
                        if viewModel.isLoading{
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                        }else{
                            HStack{
                                Image(systemName: "square.and.arrow.down.fill")
                                    .resizable()
                                    .frame(width: 24,height: 24)
                                    .foregroundColor(.white)
                                    .rotationEffect(.degrees(270))
                                    .padding(.trailing,6)
                                Text("Giriş")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .foregroundColor(isValid ? .white : .gray)
                                    .alert(isPresented: $viewModel.showAlert) {
                                        Alert(title: Text("Error"), message: Text("error"), dismissButton: .cancel())
                                        
                                    }
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: 63)
                            .background(isValid ? Color(red: 1, green: 0.48, blue: 0.22) : .gray.opacity(0.4) )
                            .cornerRadius(16)
                            
                        }
                    })
                    .shadow(
                        color: Color(red: 0.58, green: 0.68, blue: 1, opacity: 0.30), radius: 22, y: 10
                    )
                    .padding(.top,20)
                    .disabled(!isValid || viewModel.isLoading)
                    
                    HStack{
                        Text("Henüz bir hesabınız yok mu?")
                              .font(Font.custom("Poppins", size: 16))
                              .foregroundColor(Color(red: 0.12, green: 0.09, blue: 0.09));
                        NavigationLink(destination: RegisterView()) {
                            Text("Kayıt Ol")
                                .font(Font.custom("Poppins", size: 16))
                                .foregroundColor(Color(red: 1, green: 0.48, blue: 0.22))
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.7)
                    .padding(.top,10)
                }
            }
            .navigationBarBackButtonHidden(true)
            Spacer()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(LoginViewModel())
    }
}

