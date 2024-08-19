//
//  SlideMenu.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

struct SlideMenu: View {
    @State var width = UIScreen.main.bounds.width
    @EnvironmentObject var vm: LoginViewModel
    var edges = UIApplication.yourNameByValue
    @StateObject var quiz = QuizViewModel()
    var menuButtons = ["Profil Bilgilerim ","Kullanıcı Raporları","PDF","Öneri","Quiz","Çıkış Yap"]
    var menuButtonsIcon = ["person","doc.text.magnifyingglass","doc.text.fill", "paperplane.fill","bell","rectangle.portrait.and.arrow.forward"]
   
    var body: some View {
            VStack{
                HStack(spacing:0){
                    VStack(alignment:.leading){
                        VStack(alignment:.leading){
                            HStack(spacing:18){
                                Image(systemName:"person.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50,height: 50)
                                    .clipShape(Circle())
                                VStack(alignment:.leading,spacing:2){
                                    Text("Hoşgeldin,")
                                        .font(.system(size: 25))
                                        .foregroundColor(.black)
                                        .bold()
                                    
                                    Text("\(vm.getUsernameUserDefaults() ?? "User!")")
                                        .font(.system(size: 25))
                                        .foregroundColor(.black)
                                        .lineLimit(1)
                                    
                                }
                            }
                            
                            Divider()
                                .padding(.top,10)
                            NavigationView{
                                VStack{
                                    VStack{
                                        NavigationLink(destination: {
                                            ProfileView()
                                                .withInternetStatus()
                                        }, label: {
                                            MenuButtons(title: menuButtons[0], iconName: menuButtonsIcon[0])
                                        })
                                        NavigationLink(destination: {
                                            UserReports()
                                                .withInternetStatus()
                                        }, label: {
                                            MenuButtons(title: menuButtons[1], iconName: menuButtonsIcon[1])
                                        })
                                        NavigationLink(destination: {
                                            PDFsView()
                                                .withInternetStatus()
                                        }, label: {
                                            MenuButtons(title: menuButtons[2], iconName: menuButtonsIcon[2])
                                        })
                                        NavigationLink(destination: {
                                           SuggestionView()
                                                .withInternetStatus()
                                        }, label: {
                                            MenuButtons(title: menuButtons[3], iconName: menuButtonsIcon[3])
                                        })
                                        NavigationLink(destination: {
                                            QuizView()
                                                .withInternetStatus()
                                        }, label: {
                                            VStack(alignment:.leading){
                                                HStack{
                                                    ZStack {
                                                        Image(systemName: menuButtonsIcon[4])
                                                            .foregroundColor(Color.black)
                                                            .font(.system(size: 25))
                                                        
                                                        
                                                    }
                                                    Text(menuButtons[4])
                                                        .foregroundColor(.black)
                                                        .fontWeight(.regular)
                                                        .padding(.horizontal, 10)
                                                    Spacer()
                                                    Text("\(quiz.allQuiz.count)")
                                                        .foregroundColor(.black)
                                                        .bold()
                                                    
                                                }
                                                .frame(height: 50)
                                            }
                                        })
                                        
                                        Button {
                                            vm.logOutUser()
                                        } label: {
                                            VStack(alignment:.leading){
                                                HStack{
                                                    ZStack {
                                                        Image(systemName: menuButtonsIcon[5])
                                                            .foregroundColor(Color.red)
                                                            .font(.system(size: 25))
                                                        
                                                        
                                                    }
                                                    Text(menuButtons[5])
                                                        .foregroundColor(.red)
                                                        .fontWeight(.regular)
                                                        .padding(.horizontal, 10)
                                                    Spacer()
                                                    
                                                }
                                                .frame(height: 50)
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal,20)
                    .padding(.top,edges.top == 0 ? 15 : edges.top)
                    .padding(.bottom,edges.bottom == 0 ? 15 : edges.bottom)
                    .frame(width: width - 90)
                    .background(Color.white)
                    Spacer()
                } //:HSTACK
                
            }//VSTACK
            .onAppear(perform: {
                quiz.fetchAllQuiz()
            })
        }
}

#Preview {
    SlideMenu()
        .environmentObject(LoginViewModel())
}

extension UIApplication {
    static var yourNameByValue: UIEdgeInsets  {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene?.windows.first?.safeAreaInsets ?? .zero
    }
}
