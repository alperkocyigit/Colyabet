//
//  MainView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI
import PopupView

struct MainView: View {
    @StateObject var foodList = MealViewModel()
    @State var showCancel: Bool = false
    @State var dragEnabled = false
    @StateObject var receiptsViewModel = ReceiptsViewModel()
    @Binding var tabBarHidden: Bool
    @State var index: Int = 1
    @State var offset : CGFloat = 0
    @State var width = UIScreen.main.bounds.width - 90
    @State var x : CGFloat =  -UIScreen.main.bounds.width + 90
    @State var isShowing = false
    @State var result: Double = 0
    
    var body: some View {
        ZStack{
            VStack(spacing:0){
                TopBar(x: $x)
                GeometryReader{ geometry in
                    HStack(spacing: 0 ){
                        HomeView(foodList: foodList)
                            .frame(width: geometry.size.width)
                            .background(Color.white)
                        ZStack{
                            ReceiptsView(showCancel: $showCancel, viewModel: receiptsViewModel)
                                .frame(width: geometry.frame(in: .global).size.width)
                                .background(Color.white)
                            
                            Color.black.opacity(0.001)
                                .opacity(dragEnabled ? 0.5 : 0)
                                .onTapGesture(perform: {
                                    showCancel = false
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                })
                                .gesture(dragEnabled ? DragGesture()
                                    .onChanged { value in
                                        if(self.index == 1) {
                                            return
                                        }
                                    } : nil)
                        }
                        SettingsView(foodList: foodList, result: $result, isShowing: $isShowing)
                            .frame(width: geometry.size.width)
                            .background(Color.white)
                            .onTapGesture {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                            .gesture(dragEnabled ? DragGesture()
                                .onChanged { value in
                                    if(self.index == 3) {
                                        return
                                    }
                                } : nil)
                    }
                    .offset(x:self.offset)
                    .gesture(DragGesture()
                        .onChanged { value in
                            if (self.index == 1 && value.translation.width > 0) || (self.index == 3 && value.translation.width < 0) {
                                return
                            }
                            self.offset = value.translation.width - geometry.size.width * CGFloat(self.index - 1)
                        }
                        .onEnded { value in
                            if value.translation.width > 50 {
                                if self.index > 1 {
                                    self.index -= 1
                                }
                            }
                            if -value.translation.width > 50 {
                                if self.index < 3 {
                                    self.index += 1
                                }
                            }
                            self.offset = -geometry.size.width * CGFloat(self.index - 1)
                        }
                    )
                    .navigationBarBackButtonHidden()
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                        self.dragEnabled = true}
                    
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                        self.dragEnabled = false
                    }
                }
                BottomBar(index: self.$index, offset: self.$offset)
                    .offset(y:tabBarHidden ? 400 : 0)
                    .opacity(tabBarHidden ? 0 : 1)
                    .frame(height: tabBarHidden ? 0 : nil)
                
            }
            .offset(x:x + width)
            SlideMenu()
                .offset(x:x)
                .background(Color.black.opacity(x == 0 ? 0.5 : 0))
                .ignoresSafeArea(.all , edges: .vertical)
                .onTapGesture {
                    withAnimation{
                        x = -width
                    }
                }
        }
        .popup(isPresented: $isShowing) {
            HStack(alignment: .center, spacing: 12) {
                 Text("Vurulacak Ünite Sayısı:")
                    .font(.system(size: 22))
                    .foregroundColor(Color(red: 1, green: 0.48, blue: 0.22))
                    .fontWeight(.bold)
                
                Text("\(Int(result.rounded()))")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                 
                 
               }
                .frame(width:UIScreen.main.bounds.width ,height:138)
               .padding()
               .background( LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 0.98, blue: 0.95), Color(red: 1, green: 0.94, blue: 0.93)]), startPoint: .leading, endPoint: .trailing))
               .cornerRadius(60)
        } customize: {
            $0
                .type(.toast)
                .position(.bottom)
                .animation(.interpolatingSpring)
                .closeOnTapOutside(true)
                .backgroundColor(.black.opacity(0.2))
              
        }
    }
}

#Preview {
    MainView(tabBarHidden: .constant(false))
        .environmentObject(LoginViewModel())

}

struct BottomBar : View {
    
    @Binding var index : Int
    @Binding var offset : CGFloat
    var body: some View{
        HStack(spacing:10){
            Spacer()
            Button(action: {
                self.index = 1
                self.offset = -((UIScreen.main.bounds.width) * CGFloat(self.index - 1))
            }){
                VStack(spacing:0) {
                    VStack(spacing:2){
                        
                        Image(systemName: "house")
                            .resizable()
                            .frame(width:25,height:25)
                            .foregroundColor(self.index == 1 ? .white : .black)
                        Text("Home")
                            .font(.system(size: 13))
                            .foregroundColor(self.index == 1 ? .white : .black)
                    }
                }
            }
            Spacer()
            Button(action: {
                
                self.index = 2
                self.offset = -((UIScreen.main.bounds.width) * CGFloat(self.index - 1))
            }){
                VStack(spacing:0) {
                    VStack(spacing:2){
                        
                        Image(systemName: "pencil.and.list.clipboard")
                            .resizable()
                            .foregroundColor(self.index == 2 ? .white : .black)
                            .frame(width:25,height:25)
                        Text("Receipts")
                            .font(.system(size: 13))
                            .foregroundColor(self.index == 2 ? .white : .black)
                    }
                }
            }
            Spacer()
          
            Button(action: {
                self.index = 3
                self.offset = -((UIScreen.main.bounds.width) * CGFloat(self.index - 1))
            }){
                VStack(spacing:0) {
                    VStack(spacing: 2){
                        
                        Image(systemName: "syringe.fill")
                            .resizable()
                            .foregroundColor(self.index == 3 ? .white : .black)
                            .frame(width:25,height:25)
        
                        Text("Bolus")
                            .font(.system(size: 13))
                            .foregroundColor(self.index == 3 ? .white : .black)
                    }
                }
            }
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width)
        .padding(.bottom,(UIApplication.shared.windows.first?.safeAreaInsets.bottom)! - 35)
        .padding(.top,8)
        .background(Color(red: 1, green: 0.48, blue: 0.22))
    }
}
