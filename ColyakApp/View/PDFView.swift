//
//  PDFView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

struct PDFsView: View {
    @StateObject private var viewModel = PDFViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                VStack {
                    ZStack {
                        HStack {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .frame(width: 12, height: 20)
                                    .foregroundColor(.black)
                                    .padding(.horizontal)
                            })
                            Spacer()
                        }
                        
                        Text("PDF")
                            .font(.title)
                            .bold()
                            .foregroundColor(.black)
                        
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
                
                if viewModel.loading {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular)
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(viewModel.allPdf) { pdf in
                                HStack {
                                    Text(pdf.name ?? "")
                                        .padding(.leading, 5)
                                        .font(.system(size: 16))
                                        .bold()
                                        .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
                                        .lineLimit(1)
                                    Spacer()
                                    NavigationLink(destination: PDFViews(id: pdf.id, name: pdf.name)) {
                                        Image(systemName: "doc.text")
                                             .resizable()
                                             .frame(width: 20, height: 25)
                                             .foregroundColor(.orange)
                                             .bold()
                                             .padding(.horizontal)
                                    }
                                   
                                   
                                }
                                .padding(.leading)
                                .frame(width: UIScreen.main.bounds.width * 0.90, height: 70)
                                .background(.white)
                                .cornerRadius(16)
                            }
                        }
                    }
                    .padding(.top)
                    .frame(width: UIScreen.main.bounds.width)
                    .background(Color(red: 0.97, green: 0.97, blue: 0.97))
                    .refreshable(action: {
                        viewModel.pdfListData()
                    })
                }
            }
            .onAppear {
                viewModel.pdfListData()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct PDFsView_Previews: PreviewProvider {
    static var previews: some View {
        PDFsView()
    }
}
