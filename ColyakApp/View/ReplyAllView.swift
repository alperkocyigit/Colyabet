//
//  ReplyAllView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

struct ReplyAllView: View {
    let comment: Commentt
    @State private var replyText = "Cevapla"
    @State var  placeholderString = "Cevapla"
    @StateObject var vm = ReplyViewModel()
    @EnvironmentObject var loginViewModel: LoginViewModel
    @State var replyChange = false
    @State var selectedReply: Replly? = nil
  
    var body: some View {
        VStack {
            VStack{
                Text("Yanıtlar")
                    .font(.title3)
                    .frame(width: UIScreen.main.bounds.width,height: 50)
                    .fontWeight(.semibold)
                Divider()
                    .padding(.horizontal)
            }
            
            VStack{
                HStack {
                    VStack {
                        HStack{
                            Text(comment.userName ?? "")
                                .font(.system(size: 20))
                                .fontWeight(.medium)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            Text("\(formattedStringToDateAndHour(dateTimeString: comment.createdDate ?? ""))")
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                                .opacity(0.35)
                                .font(.system(size: 12))
                                .padding(.leading)
                        }
                    }
                    Spacer()
                }
                .padding(.top,5)
                .padding(.horizontal,25)
              
                HStack {
                    ScrollView{
                        Text(comment.comment ?? "")
                            .font(.system(size: 14))
                            .multilineTextAlignment(.leading)
                            .lineSpacing(7)
                            .foregroundColor(Color(red: 0.26, green: 0.26, blue: 0.26))
                            .fontWeight(.regular)
                            .padding()
                    }
                    .scrollIndicators(.automatic)
                    .padding(.bottom)
                    Spacer()
                }
                .background( Color(red: 0.54, green: 0.58, blue: 0.62, opacity: 0.06))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top,7)
                .padding(.bottom,12)
            }
            .padding(.vertical)
            .frame(width: UIScreen.main.bounds.width * 0.9,height: 250)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color(red: 0.54, green: 0.58, blue: 0.62, opacity: 0.25), radius: 40, y: 7)
            
            HStack{
                Text("Yanıtlar")
                    .font(.title)
                    .fontWeight(.heavy)
                Spacer()
            }
            .frame(width:UIScreen.main.bounds.width * 0.85, height: 30)
            .padding(.top)
            
            VStack {
                ScrollView{
                    ForEach(0..<vm.allReply.count ,id: \.self){ reply in
                        VStack{
                            HStack {
                                VStack {
                                    HStack{
                                        Text(vm.allReply[reply].userName ?? "")
                                            .font(.system(size: 12))
                                            .fontWeight(.bold)
                                            .multilineTextAlignment(.leading)
                                        
                                        
                                        Text("\(formattedStringToDate(dateTimeString: vm.allReply[reply].createdDate ?? ""))")
                                            .fontWeight(.bold)
                                            .foregroundColor(.gray)
                                            .opacity(0.35)
                                            .font(.system(size: 12))
                                            .padding(.leading)
                                        
                                       
                                        Spacer()
                                        
                                        if loginViewModel.getUsernameUserDefaults() == vm.allReply[reply].userName{
                                            
                                            Menu{
                                                Button(action: {
                                                    selectedReply = vm.allReply[reply]
                                                    vm.replly = selectedReply?.reply ?? ""
                                                    replyChange.toggle()

                                                }) {
                                                    Label("Düzenle", systemImage: "square.and.pencil")
                                                }
                                                Button(role:.destructive, action: {
                                                    if let replyId = vm.allReply[reply].replyId {
                                                        vm.deleteReply(byId: replyId)
                                                    }
                                                }) {
                                                    Label("Sil", systemImage: "trash")
                                                        .foregroundColor(.red)
                                                }
                                            }label: {
                                                Label("", systemImage: "ellipsis")
                                                    .font(.system(size: 18))
                                                    .foregroundColor(.black)
                                            }
                                            .menuStyle(.button)
                                        }
                                        
                                    }
                                }
                                Spacer()
                                
                            }
                            .padding(.top,5)
                            .padding(.horizontal,25)
                        
                            HStack {
                                Text(vm.allReply[reply].reply ?? "")
                                        .font(.system(size: 13))
                                        .multilineTextAlignment(.leading)
                                        .lineSpacing(7)
                                        .foregroundColor(Color(red: 0.26, green: 0.26, blue: 0.26))
                                        .fontWeight(.regular)
                                        .padding()
                                
                              
                                
                            }
                            .background( Color(red: 0.54, green: 0.58, blue: 0.62, opacity: 0.06))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .padding(.top,7)
                            .padding(.bottom,12)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.85)
                        .background(Color.white)
                        .cornerRadius(20)
                        .scrollIndicators(.hidden)
                        .scrollContentBackground(.hidden)
                        .padding(.vertical)
                        
                        Divider()
                       
                    }
                }
                .scrollIndicators(.hidden)
            }
            .frame(width:UIScreen.main.bounds.width * 0.85)
        }
        .sheet(isPresented: $replyChange,onDismiss: {
            vm.fetchAllReply(byId: comment.commentId ?? 0)
        },content: {
            VStack{
                if let selectedReply = selectedReply {
                    ChangeReplyView(vm: vm, reply: selectedReply)
                }
            }
            .presentationDetents([.fraction(0.40)])
            .presentationCornerRadius(30)
            .presentationDragIndicator(.visible)
        })
        .padding(.vertical)
        .onAppear(
            perform: {
                vm.commentId = comment.commentId
                vm.fetchAllReply(byId: comment.commentId ?? 0)
            })
    }
}
struct ReplyAllView_Previews: PreviewProvider {
    static var previews: some View {
        ReplyAllView(comment: Commentt.init(commentId: 1, userName: "alper", receiptName: "elma", createdDate: "2024-07-13T14:50:00.771Z", comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."))
    }
}

struct ReplyAddView: View {
    @StateObject var vm = ReplyViewModel()
    @State var disabled : Bool = false
    @Environment(\.presentationMode) var presentationMode
    let comment: Commentt
    @State var  placeholderString = "Cevapla"
    @State var characterLimit: Int = 60
    @State var typedCharacters: Int = 0
    
  
    var body: some View {
        VStack {
            VStack{
                Text("Yanıtla")
                    .font(.title3)
                    .frame(width: UIScreen.main.bounds.width,height: 50)
                    .fontWeight(.semibold)
                Divider()
                    .padding(.horizontal)
            }
            
            VStack{
                HStack {
                    VStack {
                        HStack{
                            Text(comment.userName ?? "")
                                .font(.system(size: 20))
                                .fontWeight(.medium)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Text("\(formattedStringToDate(dateTimeString: comment.createdDate ?? ""))")
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                                .opacity(0.35)
                                .font(.system(size: 13))
                                .padding(.leading)
                        }
                    }
                    Spacer()
                }
                .padding(.top,5)
                .padding(.horizontal,25)
                Divider()
                    .padding(.horizontal)
                  
                HStack {
                    ScrollView{
                        Text(comment.comment ?? "")
                            .font(.system(size: 14))
                            .multilineTextAlignment(.leading)
                            .lineSpacing(7)
                            .foregroundColor(Color(red: 0.26, green: 0.26, blue: 0.26))
                            .fontWeight(.regular)
                            .padding()
                    }
                    .scrollIndicators(.hidden)
                    .padding(.bottom)
                    Spacer()
                }
                .background( Color(red: 0.54, green: 0.58, blue: 0.62, opacity: 0.06))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top,7)
                .padding(.bottom,12)
            }
            .padding(.vertical)
            .frame(width: UIScreen.main.bounds.width * 0.9)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color(red: 0.54, green: 0.58, blue: 0.62, opacity: 0.25), radius: 40, y: 7)

           
            VStack {
                ZStack {
                    TextEditor(text: $vm.replly)
                        .foregroundColor(self.vm.replly == placeholderString ? .gray : .primary)
                        .scrollContentBackground(.hidden)
                        .scrollDisabled(true)
                        .padding()
                        .onChange(of: vm.replly) { result in
                            typedCharacters =  vm.replly.count
                            vm.replly = String( vm.replly.prefix(characterLimit))
                            
                            if vm.replly != "" && vm.replly != "Cevapla" {
                                disabled = true
                            }
                            else{
                                disabled = false
                            }
                        }
                        .onTapGesture {
                            if self.vm.replly == placeholderString {
                                self.vm.replly = ""
                            }
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.9)
                .background(Color(red: 0.98, green: 0.98, blue: 0.98))
                .cornerRadius(16)
                .padding(.top)
                
                HStack {
                    Spacer()
                    Text("\(typedCharacters) / \(characterLimit)")
                        .foregroundColor(vm.replly.count < characterLimit ? .gray : .red)
                }
                .padding(.trailing)
                .padding(.bottom)
                .frame(width: UIScreen.main.bounds.width * 0.9)
            }
               
            Spacer()
            Button(action: {
                vm.addReply(byId: comment.commentId ?? 0)
                presentationMode.wrappedValue.dismiss()
                hideKeyboard()
            }) {
                Text("Yanıtla")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.9,height: 56)
                    .background(disabled ? Color(red: 1, green: 0.48, blue: 0.22) : Color.gray)
                    .cornerRadius(30)
                    .padding(.horizontal)
            }
            .disabled(!disabled)
        }
        .padding(.vertical)
    }
}
struct ReplyAddView_Previews: PreviewProvider {
    static var previews: some View {
        ReplyAddView(vm: ReplyViewModel(), comment:Commentt(commentId: 1, userName: "alper", receiptName: "elma", createdDate: "2024-07-13T14:50:00.771Z", comment: "Lorem "))
    }
}

struct ChangeReplyView: View {
    @ObservedObject var vm: ReplyViewModel
    let reply: Replly
    @State var disabled : Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State var  placeholderString = "Cevapla"
    @State var characterLimit: Int = 60
    @State var typedCharacters: Int = 0
    
   
  
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    TextEditor(text: $vm.replly)
                        .foregroundColor(self.vm.replly == placeholderString ? .gray : .primary)
                        .scrollContentBackground(.hidden)
                        .scrollDisabled(true)
                        .padding()
                        .onChange(of: vm.replly) { result in
                            typedCharacters =  vm.replly.count
                            vm.replly = String( vm.replly.prefix(characterLimit))
                            
                            if vm.replly != "" && vm.replly != "Cevapla" {
                                disabled = true
                            }
                            else{
                                disabled = false
                            }
                        }
                        .onTapGesture {
                            if self.vm.replly == placeholderString {
                                self.vm.replly = ""
                            }
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.9)
                .background(Color(red: 0.98, green: 0.98, blue: 0.98))
                .cornerRadius(16)
                .padding(.top)
                
                HStack {
                    Spacer()
                    Text("\(typedCharacters) / \(characterLimit)")
                        .foregroundColor(vm.replly.count < characterLimit ? .gray : .red)
                }
                .padding(.trailing)
                .padding(.bottom)
                .frame(width: UIScreen.main.bounds.width * 0.9)
            }
               
            Spacer()
            Button(action: {
                vm.changeReply(byId: reply.replyId ?? 0, newReply: vm.replly )
                presentationMode.wrappedValue.dismiss()
                hideKeyboard()
            }) {
                Text("Yanıtla")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.9,height: 56)
                    .background(disabled ? Color(red: 1, green: 0.48, blue: 0.22) : Color.gray)
                    .cornerRadius(30)
                    .padding(.horizontal)
            }
            .disabled(!disabled)
        }
        .padding(.vertical)
        .onAppear {
            typedCharacters = vm.replly.count
        }
    }
}
struct ChangeReplyView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeReplyView(vm: ReplyViewModel(), reply: Replly.init(replyId: 1, userName: "", createdDate: "", reply: ""))
    }
}
