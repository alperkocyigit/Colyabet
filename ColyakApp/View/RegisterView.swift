//
//  RegisterView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var registerViewModel = RegisterViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var repeatpassword : String = ""
    @State private var isValidEmail = true
    @State private var isValidPassword = true
    
    
    var body: some View {
        if !registerViewModel.emailVerifacitonView{
            VStack{
                VStack {
                    ZStack {
                        HStack {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                                registerViewModel.password = ""
                                registerViewModel.email = ""
                                registerViewModel.name = ""
                            }, label: {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .frame(width: 10, height: 20)
                                    .foregroundColor(.black)
                                    .padding(.horizontal)
                                
                            })
                            Spacer()
                        }
                        
                        Text("Kayıt Ol")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.black)
                    }
                } // NavigationTitle and Back Button
                .padding(.top)
                .frame(width: UIScreen.main.bounds.width)
                NavigationView{
                    VStack{
                        VStack(alignment: .center, spacing: 20) {
                            VStack {
                                Image("login")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            }
                            .padding(.bottom,5)
                            
                            Text("Size nasıl hitap edelim")
                                .font(.title3)
                                .lineSpacing(24)
                                .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                                .padding(.bottom,5)
                                .padding(.top,15)
                            
                            HStack {
                                Image(systemName: "person")
                                    .resizable()
                                    .frame(width: 18, height: 17)
                                    .foregroundColor(.gray)
                                    .padding(.leading, 15)
                                
                                TextField("Kullanıcı Adı", text: $registerViewModel.name)
                                    .padding(.leading,5)
                                    .font(Font.custom("Poppins", size: 14))
                                    .foregroundColor(Color(red: 0.68, green: 0.64, blue: 0.65))
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.80, height: 60)
                            .background(Color(red: 0.97, green: 0.97, blue: 0.97))
                            .cornerRadius(16)
                            
                            HStack {
                                Image(systemName: "envelope")
                                    .resizable()
                                    .frame(width: 20, height: 17)
                                    .foregroundColor(.gray)
                                    .padding(.leading, 15)
                                
                                TextField("E-posta", text: $registerViewModel.email)
                                    .textContentType(.emailAddress)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .padding(.leading,5)
                                    .font(Font.custom("Poppins", size: 14))
                                    .foregroundColor(Color(red: 0.68, green: 0.64, blue: 0.65))
                                    .onChange(of: registerViewModel.email, perform: { value in
                                        isValidEmail = isValidEmailFormat(email: registerViewModel.email)
                                    })
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
                                
                                SecureField("Şifre", text: $registerViewModel.password)
                                    .padding(.leading,7)
                                    .font(Font.custom("Poppins", size: 14))
                                    .lineSpacing(18)
                                    .foregroundColor(Color(red: 0.68, green: 0.64, blue: 0.65))
                                    .onChange(of: registerViewModel.password, perform: { value in
                                        isValidPassword = isValidPasswordFormat(password: registerViewModel.password)
                                    })
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
                                
                                SecureField("Şifre Tekrar", text: $repeatpassword)
                                    .padding(.leading,7)
                                    .font(Font.custom("Poppins", size: 14))
                                    .lineSpacing(18)
                                    .foregroundColor(Color(red: 0.68, green: 0.64, blue: 0.65))
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.80, height: 60)
                            .background(Color(red: 0.97, green: 0.97, blue: 0.97))
                            .cornerRadius(16)
                            
                            VStack {
                                Button(action: {
                                    if registerViewModel.name.isEmpty || registerViewModel.email.isEmpty || registerViewModel.password.isEmpty || repeatpassword.isEmpty{
                                        
                                        registerViewModel.alertType = .incompleteFields
                                        
                                    }else if repeatpassword != registerViewModel.password{
                                        registerViewModel.alertType = .passwordMismatch
                                        
                                    }else if !isValidEmail{
                                        registerViewModel.alertType = .validationEmail
                                        
                                    }else if !isValidPassword{
                                        registerViewModel.alertType = .validationPassword
                                    }
                                    else{
                                        registerViewModel.registerUser()
                                    }
                                    
                                }, label: {
                                    HStack{
                                        Text("Kayıt Ol")
                                            .font(.system(size: 18))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 63)
                                    .background(Color(red: 1, green: 0.48, blue: 0.22))
                                    .cornerRadius(16)
                                })
                                .shadow(
                                    color: Color(red: 0.58, green: 0.68, blue: 1, opacity: 0.30), radius: 22, y: 10
                                )
                                .padding(.top,10)
                            }
                            .alert(item: $registerViewModel.alertType) { alertType in
                                switch alertType {
                                case .passwordMismatch:
                                    return Alert(title: Text("Hata"), message: Text("Şifreler uyuşmuyor"), dismissButton: .cancel())
                                case .incompleteFields:
                                    return Alert(title: Text("Hata"), message: Text("Tüm alanları doldurun."), dismissButton: .cancel())
                                case .validationEmail:
                                    return  Alert(title: Text("Yanlış Email Formatı"), message: Text("Girdiğiniz email hesabınızı doğruluğundan emin olun. "), dismissButton: .cancel())
                                case .validationPassword:
                                    return  Alert(title: Text("Yanlış Şifre Biçimi"), message: Text("Şifre en az 8 karakterden oluşmalıdır."), dismissButton: .cancel())
                                case .currentAccount:
                                    return  Alert(title: Text("Mevcut Hesap"), message: Text("Böyle bir hesap zaten mevcut."), dismissButton: .cancel())
                                case .validationPasswordAndCurrentAccount:
                                    return Alert(title: Text("Mevcut Hesap ve Şifre Hatalı "), message: Text("Böyle bir hesap zaten mevcut ve şifre en az 8 karakterden oluşmalıdır.."), dismissButton: .cancel())
                                }
                            }
                            
                            HStack{
                                Text("Zaten bir hesabın var mı?")
                                    .font(Font.custom("Poppins", size: 16))
                                    .foregroundColor(Color(red: 0.12, green: 0.09, blue: 0.09));
                                Button(action: {
                                    self.presentationMode.wrappedValue.dismiss()
                                }, label: {
                                    Text("Giriş Yap")
                                        .font(Font.custom("Poppins", size: 16))
                                        .foregroundColor(Color(red: 1, green: 0.48, blue: 0.22))
                                })
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.7)
                            .padding(.top,10)
                            
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }else{
            MembershipOTP(registerViewModel:registerViewModel)
        }
    }
}

    func isValidEmailFormat(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPasswordFormat(password: String) -> Bool {
        let passwordRegex = "^.{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
    

#Preview {
    RegisterView(registerViewModel: RegisterViewModel())
}
