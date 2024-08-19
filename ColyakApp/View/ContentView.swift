//
//  ContentView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var foodList = MealViewModel()
    @EnvironmentObject var vm : LoginViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State private var tabBarHidden = false
    
    var body: some View {
        NavigationStack {
            if networkMonitor.isConnected{
                if vm.isLoggedIn{
                    MainView(tabBarHidden: $tabBarHidden)
                        .onAppear {
                            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                                withAnimation {
                                    self.tabBarHidden = true
                                }
                            }
                            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notification in
                                withAnimation {
                                    self.tabBarHidden = false
                                }
                            }
                        }
                       
                }
                else{
                    VStack{
                        LoginView()
                            .onTapGesture {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        HStack {
                            Image(systemName: "wifi")
                                .foregroundColor(.green)
                                .font(.title3)
                            Text("İnternet bağlantısı mevcut")
                                .foregroundColor(.green)
                                .font(.system(size: 12))
                        }
                    }
                    .ignoresSafeArea(.keyboard)
                }
                
            }else{
                ContentUnavailableView("İnternet bağlantısı yok",
                    systemImage: "wifi.exclamationmark",description: Text("Lütfen bağlantınızı kontrol edin ve tekrar deneyin.")
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(foodList: MealViewModel())
            .environmentObject(NetworkMonitor())
            .environmentObject(LoginViewModel())
    }
}
