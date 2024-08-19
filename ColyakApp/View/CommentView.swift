//
//  CommentView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 13.07.2024.
//

import SwiftUI

struct CommentView: View {
    @StateObject var commentViewModel = CommentViewModel()
    let receipt:Receipt
    @State var replyAdd:Bool = false
    @State var commentAdd:Bool = false
    @State var replyAll:Bool = false
    @State var changeComment:Bool = false
    @State var selectedComment: Commentt? = nil
    @StateObject var repllyViewModel = ReplyViewModel()

    
    var body: some View {
        ScrollView{
            VStack(spacing:20){
                ForEach(0..<commentViewModel.allCommentAndReplly.count, id: \.self) { comment in
                    CommentDetailView(viewModel: commentViewModel, comment: commentViewModel.allCommentAndReplly[comment].commentResponse ?? Commentt(commentId: 1, userName: "Hata", receiptName: "receipt", createdDate: "invalid Date", comment: "hata") , receipt: receipt, replyAdd: $replyAdd, changeComment: $changeComment, replyAll: $replyAll, selectedComment: $selectedComment, onReplyAllTapped: { comment in
                        selectedComment = comment
                    })
                }
                .frame(width: UIScreen.main.bounds.width)
                .padding(.top,20)
                .padding(.bottom,20)
            }
            .onChange(of: changeComment) { }
            .onChange(of: replyAll) { }
            .onChange(of: replyAdd) { }
            .scrollIndicators(.hidden)
            .sheet(isPresented: $commentAdd,onDismiss: {
                commentViewModel.fetchAllCommentAndReply(receiptId: receipt.id)
            }, content: {
                VStack{
                    CommentAddView(vm: commentViewModel, receipt: receipt)
                }
                .presentationDetents([.fraction(0.45)])
                .presentationCornerRadius(30)
                .presentationDragIndicator(.visible)
            })
            .sheet(isPresented: $replyAdd,onDismiss: {
                commentViewModel.fetchAllCommentAndReply(receiptId: receipt.id)
            },content: {
                VStack{
                    if let comment = selectedComment{
                        ReplyAddView(comment: comment)
                    }
                }
                .presentationDetents([.fraction(0.70)])
                .presentationCornerRadius(30)
                .presentationDragIndicator(.visible)
            })
            .sheet(isPresented: $replyAll,onDismiss: {
                commentViewModel.fetchAllCommentAndReply(receiptId: receipt.id)
            },content: {
                VStack{
                    if let comment = selectedComment{
                        ReplyAllView(comment: comment)
                    }
                }
                .presentationDetents([.large])
                .presentationCornerRadius(30)
                .presentationDragIndicator(.visible)
            })
            
            .sheet(isPresented: $changeComment,onDismiss: {
                commentViewModel.fetchAllCommentAndReply(receiptId: receipt.id)
            },content: {
                VStack{
                    if let comment = selectedComment{
                        ChangeCommentView(vm: commentViewModel, receipt: receipt, comment: comment)
                    }
                }
                .presentationDetents([.fraction(0.40)])
                .presentationCornerRadius(30)
                .presentationDragIndicator(.visible)
            })
        }
        .refreshable{
            commentViewModel.fetchAllCommentAndReply(receiptId: receipt.id)
        }
        .frame(width: UIScreen.main.bounds.width)
        .overlay(alignment: .bottomTrailing) {
            Button(action: {
                commentAdd.toggle()
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .foregroundColor(Color(red: 1, green: 0.48, blue: 0.22))
                    HStack{
                        HStack{
                            Text("Yorum ekle")
                                .font(.system(size: 15))
                                .foregroundColor(.white)
                                .bold()
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.trailing,16)
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.title2)
                            .bold()
                    }
                }
                .frame(width: 160, height: 60)
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.20), radius: 22, y: 11
                )
            })
            .padding(.trailing)
            .padding(.bottom,10)
        }
        .onAppear(perform: {
            commentViewModel.receiptId = receipt.id
            commentViewModel.fetchAllCommentAndReply(receiptId: receipt.id)
        })
    }
}
struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(commentViewModel: CommentViewModel(), receipt:Receipt.init(id: 1, receiptDetails: ["elma","armut"], receiptItems: [ReceiptItem.init(id: 1, productName: "elma", unit: 2.0, type: "")], receiptName: "elma", nutritionalValuesList: [NutritionalValuesList.init(id: 1, unit: 2, type: "", carbohydrateAmount: 2.0, proteinAmount: 5.0, fatAmount: 6.0, calorieAmount: 100.0)], imageId: 1))
    }
}

struct CommentDetailView: View {
    @EnvironmentObject var vm : LoginViewModel
    @ObservedObject var viewModel: CommentViewModel
    let comment : Commentt
    let receipt:Receipt
    @Binding var replyAdd:Bool
    @Binding var changeComment:Bool
    @Binding var replyAll:Bool
    @Binding var selectedComment: Commentt?
    var onReplyAllTapped: (Commentt) -> Void
    
    var body: some View {
        VStack{
            HStack {
                VStack {
                    HStack{
                        Text("\(comment.userName ?? "")")
                            .font(.system(size: 20))
                            .multilineTextAlignment(.leading)
                            .bold()
                        
                        Text("\(formattedStringToDate(dateTimeString: comment.createdDate ?? ""))")
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .opacity(0.35)
                            .font(.system(size: 12))
                            .padding(.leading)
                        
                        Spacer()
                        if vm.getUsernameUserDefaults() == comment.userName{
                            Menu{
                                
                                Button(action: {
                                    selectedComment = comment
                                    viewModel.commentt = selectedComment?.comment ?? ""
                                    changeComment.toggle()
                                    
                                }) {
                                    Label("Düzenle", systemImage: "square.and.pencil")
                                }
                                
                                Button(role:.destructive, action: {
                                    if let commentId = comment.commentId{
                                        viewModel.deleteComment(byId: commentId)
                                        
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
            Divider()
                .padding(.horizontal)
              
            HStack {
                Text("\(comment.comment ?? "")")
                    .font(.system(size: 14))
                    .multilineTextAlignment(.leading)
                    .lineSpacing(7)
                    .foregroundColor(Color(red: 0.26, green: 0.26, blue: 0.26))
                    .fontWeight(.regular)
                    .padding()
                Spacer()
            }
            .background(Color(red: 0.54, green: 0.58, blue: 0.62, opacity: 0.06))
            .cornerRadius(15)
            .padding(.horizontal)
            .padding(.top,7)
            .padding(.bottom,12)
            .frame(width: UIScreen.main.bounds.width * 0.95)
            
            HStack(spacing:15){
                HStack {
                    Button(action: {
                        replyAll.toggle()
                        onReplyAllTapped(comment)
                    }, label: {
                        HStack(spacing:3) {
                            Image(systemName: "message")
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 1, green: 0.48, blue: 0.22))
                            Text("\(viewModel.allCommentAndReplly.first{$0.commentResponse?.commentId == comment.commentId}?.replyResponses?.count ?? 0)")
                                .font(.system(size: 14))
                                .foregroundColor(Color(red: 1, green: 0.48, blue: 0.22))
                                .fontWeight(.semibold)
                        }
                })
                }
                .frame(width: 60,height: 30)
                .background(.white)
                .cornerRadius(10)
                
                HStack{
                    Button(action: {
                        replyAdd.toggle()
                        onReplyAllTapped(comment)
                    }, label: {
                        Text("Yanıtla")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 1, green: 0.48, blue: 0.22))
                })
                }
                .frame(width: 60,height: 30)
                .background(.white)
                .cornerRadius(10)
               
               
                Spacer()
            }
            .padding(.leading,20)
        }
        .padding(.vertical)
        .frame(width: UIScreen.main.bounds.width * 0.9)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color(red: 0.54, green: 0.58, blue: 0.62, opacity: 0.25), radius: 40, y: 7)
    }
}
struct CommentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CommentDetailView(viewModel: CommentViewModel(), comment: Commentt(commentId: 1, userName: "Alper", receiptName: "elma", createdDate: "2024-07-13T14:50:00.771Z", comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."), receipt: Receipt(id: 1, receiptDetails: [""], receiptItems: [ReceiptItem.init(id: 1, productName: "", unit: 2.0, type: "")], receiptName: "", nutritionalValuesList: [NutritionalValuesList.init(id: 1, unit: 2, type: "", carbohydrateAmount: 2.0, proteinAmount: 3.0, fatAmount: 3.0, calorieAmount: 3.0)], imageId: 1), replyAdd: .constant(false), changeComment: .constant(false), replyAll: .constant(false), selectedComment: .constant(Commentt?.none), onReplyAllTapped: { _ in })
            .environmentObject(LoginViewModel())
    }
}

struct ChangeCommentView: View {
    @ObservedObject var vm: CommentViewModel
    let receipt:Receipt
    let comment : Commentt
    @State var characterLimit: Int = 60
    @State var typedCharacters: Int = 0
    @State var disabled : Bool = false
    @State var  placeholderString = "Yorum ekle"
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            VStack{
                Text("Yorumu Güncelle")
                    .font(.title3)
                    .frame(width: UIScreen.main.bounds.width,height: 50)
                    .fontWeight(.semibold)
                Divider()
                    .padding(.horizontal)
            }
            Spacer()
            VStack {
                ZStack {
                    TextEditor(text: $vm.commentt)
                        .foregroundColor(self.vm.commentt == placeholderString ? .gray : .primary)
                        .scrollContentBackground(.hidden)
                        .scrollDisabled(true)
                        .padding()
                        .onChange(of: vm.commentt) { result in
                            typedCharacters =  vm.commentt.count
                            vm.commentt = String( vm.commentt.prefix(characterLimit))
                            if vm.commentt != "" && vm.commentt != "Yorum ekle" {
                                disabled = true
                            }
                            else{
                                disabled = false
                            }
                        }
                        .onTapGesture {
                            if self.vm.commentt == placeholderString {
                                self.vm.commentt = ""
                               
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
                        .foregroundColor(vm.commentt.count < characterLimit ? .gray : .red)
                }
                .padding(.trailing)
                .padding(.bottom)
                .frame(width: UIScreen.main.bounds.width * 0.9)
            }
               
            Spacer()
            Button(action: {
                vm.changeComment(byId: comment.commentId ?? 0)
                presentationMode.wrappedValue.dismiss()
                hideKeyboard()
            })
            {
                Text("Güncelle")
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
        .onAppear(perform: {
            typedCharacters = vm.commentt.count
        })
        .padding(.vertical)
    }
}

struct ChangeCommentView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeCommentView(vm: CommentViewModel(), receipt: Receipt.init(id: 1, receiptDetails: [""], receiptItems: [ReceiptItem.init(id: 1, productName: "", unit: 2.0, type: "")], receiptName: "", nutritionalValuesList: [NutritionalValuesList.init(id: 1, unit: 1, type: "", carbohydrateAmount: 2.0, proteinAmount: 2.0, fatAmount: 2.0, calorieAmount: 2.0)], imageId: 1), comment: Commentt.init(commentId: 1, userName: "", receiptName: "", createdDate: "", comment: ""))
    }
}





struct CommentAddView: View {
    @ObservedObject var vm: CommentViewModel
    let receipt:Receipt
    @State var characterLimit: Int = 60
    @State var typedCharacters: Int = 0
    @State var disabled : Bool = false
    @State var  placeholderString = "Yorum ekle"
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            VStack{
                Text("Yorum Yap")
                    .font(.title3)
                    .frame(width: UIScreen.main.bounds.width,height: 50)
                    .fontWeight(.semibold)
                Divider()
                    .padding(.horizontal)
            }
            Spacer()
            VStack {
                ZStack {
                    TextEditor(text: $vm.commentt)
                        .foregroundColor(self.vm.commentt == placeholderString ? .gray : .primary)
                        .scrollContentBackground(.hidden)
                        .scrollDisabled(true)
                        .padding()
                        .onChange(of: vm.commentt) { result in
                            typedCharacters =  vm.commentt.count
                            vm.commentt = String( vm.commentt.prefix(characterLimit))
                            if vm.commentt != "" && vm.commentt != "Yorum ekle" {
                                disabled = true
                            }
                            else{
                                disabled = false
                            }
                        }
                        .onTapGesture {
                            if self.vm.commentt == placeholderString {
                                self.vm.commentt = ""
                               
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
                        .foregroundColor(vm.commentt.count < characterLimit ? .gray : .red)
                }
                .padding(.trailing)
                .padding(.bottom)
                .frame(width: UIScreen.main.bounds.width * 0.9)
            }
               
            Spacer()
            Button(action: {
                vm.addComment(byId: receipt.id)
                presentationMode.wrappedValue.dismiss()
                hideKeyboard()
            })
            {
                Text("Ekle")
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

struct CommentAddView_Previews: PreviewProvider {
    static var previews: some View {
        CommentAddView(vm: CommentViewModel(), receipt: Receipt.init(id: 1, receiptDetails: [""], receiptItems: [ReceiptItem.init(id: 1, productName: "", unit: 2.0, type: "")], receiptName: "", nutritionalValuesList: [NutritionalValuesList.init(id: 1, unit: 1, type: "", carbohydrateAmount: 2.0, proteinAmount: 2.0, fatAmount: 2.0, calorieAmount: 2.0)], imageId: 1))
    }
}
