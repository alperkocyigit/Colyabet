//
//  ModelScannerView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI
import CarBode
import AVFoundation
import Combine

struct cameraFrame: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            let height = rect.height
            
            path.addLines( [
                
                CGPoint(x: 0, y: height * 0.25),
                CGPoint(x: 0, y: 0),
                CGPoint(x:width * 0.25, y:0)
            ])
            
            path.addLines( [
                
                CGPoint(x: width * 0.75, y: 0),
                CGPoint(x: width, y: 0),
                CGPoint(x:width, y:height * 0.25)
            ])
            
            path.addLines( [
                
                CGPoint(x: width, y: height * 0.75),
                CGPoint(x: width, y: height),
                CGPoint(x:width * 0.75, y: height)
            ])
            
            path.addLines( [
                
                CGPoint(x:width * 0.25, y: height),
                CGPoint(x:0, y: height),
                CGPoint(x:0, y:height * 0.75)
               
            ])
            
        }
    }
}

struct ModalScannerView: View {
    @State private var cancellables = Set<AnyCancellable>()
    @State private var isCameraActive = true
    @State private var isShowingSheet = false
    @State private var showDetailView = false
    @State private var isNotFound = false
    @State var barcodeValue = ""
    @State var cameraPosition = AVCaptureDevice.Position.back
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var barcodeViewModel = BarcodeDetailsViewModel()
    @StateObject var sharedViewModel = SharedViewModel()
    
    var body: some View {
        VStack{
            VStack {
                ZStack {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .frame(width: 12, height: 20)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .fontWeight(.bold)
                        })
                        Spacer()
                    }
                    
                    Text("Barcode Okuyucu")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    
                }
            }
            .frame(width: UIScreen.main.bounds.width)
            
            VStack {
                if isCameraActive{
                    CBScanner(
                        supportBarcode: .constant([.qr,.ean13]),
                        cameraPosition: $cameraPosition,
                        mockBarCode: .constant(BarcodeData(value:"My Test Data", type: .qr))
                    ){ barcode in
                        sharedViewModel.barcodeValue = barcode.value
                        isCameraActive = false // Barkod okunduktan sonra kamerayı kapat
                        isShowingSheet = true // Sheet'i göster
                    }
                onDraw: {
                    /*print("Preview View Size = \($0.cameraPreviewView.bounds)")
                     print("Barcode Corners = \($0.corners)")*/
                    
                    let lineColor = UIColor.green
                    let fillColor = UIColor(red: 0, green: 1, blue: 0.2, alpha: 0.4)
                    //Draw Barcode corner
                    $0.draw(lineWidth: 1, lineColor: lineColor, fillColor: fillColor)
                    
                }
                .overlay(
                    cameraFrame()
                        .stroke(lineWidth: 5)
                        .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.width * 0.6)
                        .foregroundColor(.blue)
                )}
                else{
                    EmptyView()
                    Spacer()
                }
            }
            .padding(.bottom,30)
            .edgesIgnoringSafeArea(.all)
            .sheet(isPresented: $isShowingSheet , onDismiss: {
                isCameraActive = true
                isNotFound = false
            }) {
                NavigationView {
                    VStack {
                        HStack{
                            Spacer()
                            Text("Barkod Numarası")
                                .font(.title3)
                                .foregroundColor(.orange)
                                .padding(.top)
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        TextField("Barkod Numarası", text: $sharedViewModel.barcodeValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .padding(.bottom)
                        HStack{
                            Button("Ara") {
                                barcodeViewModel.barcodeCodeSearch(by: sharedViewModel.barcodeValue)
                                hideKeyboard()
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.all,8)
                            .background(Color.orange)
                            .cornerRadius(12)
                            if isNotFound {
                                NavigationLink {
                                    SuggestionView(sharedViewModel: sharedViewModel)
                                } label: {
                                    Text("Ürünü öner")
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                        .padding(.all,8)
                                        .background(Color.orange)
                                        .cornerRadius(12)
                                }
                            }
                        }
                        if isNotFound{
                            Text("Ürün bulunamadı!")
                                .foregroundColor(.red)
                                .fontWeight(.bold)
                        }
                    }
                }
                .presentationDetents([.height(UIScreen.main.bounds.height * 0.25)])
                .presentationCornerRadius(50)
            }
            NavigationLink(destination: BarcodeDetailView(selectedBarcodes: barcodeViewModel), isActive: $showDetailView) {
                EmptyView()
            }
        }
        .background(Color.black)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            barcodeViewModel.$isFound
                .compactMap { $0 }
                .sink { isFound in
                    if isFound {
                        isShowingSheet = false
                        isCameraActive = false
                        showDetailView = true
                    }else{
                        isNotFound = true
                    }
                }
                .store(in: &cancellables)
            isCameraActive = true
        }
    }
}

struct ModalScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ModalScannerView()
    }
}

class SharedViewModel:ObservableObject{
    @Published var barcodeValue: String = ""
}

