//
//  PDFViews.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI
import PDFKit

struct PDFViews: View {
    let id: Int?
    let name: String?
    @State private var pdfDocument: PDFDocument?
    @State private var currentPage: Int = 0
    @State private var pageCount: Int = 0
    @State private var desiredPage: String = "1"
    @FocusState var isTextFieldFocus:Bool
    @State private var fileURL: URL?
    @State private var showDocumentInteraction = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            if let pdfDocument = pdfDocument {
                PDFKitRepresentedView(pdfDocument: pdfDocument, currentPage: $currentPage)
                pageController
            } else {
                ProgressView()
                    .onAppear(perform: loadPDF)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("PDF Durumu"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
        }
        .padding(.horizontal)
        .navigationBarItems(trailing:HStack{
            Button(action: sharePDF) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.black)
            }
            Button(action: savePDFToPhone) {
                Image(systemName: "square.and.arrow.down")
                    .foregroundColor(.black)
            }
        })
    }
    
    var pageController: some View {
        HStack {
            Button(action: firstPage) {
                Image(systemName: "arrow.left.to.line.circle")
                    .font(.title)
                    .tint(.black)
            }
            .disabled(currentPage <= 0)
            
            Button(action: previousPage) {
                Image(systemName: "arrow.left.circle")
                    .font(.title)
                    .tint(.black)
            }
            .disabled(currentPage <= 0)
            
            TextField("\(currentPage + 1)", text: $desiredPage, onCommit: {
                goToPage()
            })
            .frame(width: 50)
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .focused($isTextFieldFocus)
            .toolbar{
                ToolbarItem(placement: .keyboard){
                    HStack{
                        Spacer()
                        Button("Onay") {
                            isTextFieldFocus = false
                            goToPage()
                        }
                    }
                }
            }
            
            Text("/ \(pageCount)")
                .padding(.horizontal)
            
            Button(action: nextPage) {
                Image(systemName: "arrow.right.circle")
                    .font(.title)
                    .tint(.black)
            }
            .disabled(currentPage >= pageCount - 1)
            
            Button(action: lastPage) {
                Image(systemName: "arrow.right.to.line.circle")
                    .font(.title)
                    .tint(.black)
            }
            .disabled(currentPage >= pageCount - 1)
        }
        .padding()
    }
    
    func goToPage() {
        if let pageNumber = Int(desiredPage), pageNumber > 0, pageNumber <= pageCount {
            currentPage = pageNumber - 1
        } else {
            desiredPage = "\(currentPage + 1)"
        }
    }
    
    func loadPDF() {
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/image/get/\(id ?? 1)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            if let pdfDocument = PDFDocument(data: data) {
                DispatchQueue.main.async {
                    self.pdfDocument = pdfDocument
                    self.pageCount = pdfDocument.pageCount
                    self.currentPage = 0
                    
                }
            }
        }.resume()
    }
    
    func previousPage() {
        if currentPage > 0 {
            currentPage -= 1
            desiredPage = "\(currentPage + 1)"
        }
    }
    
    func firstPage() {
        currentPage = 0
        desiredPage = "1"
    }
    
    func nextPage() {
        if currentPage < pageCount - 1 {
            currentPage += 1
            desiredPage = "\(currentPage + 1)"
        }
    }
    
    func lastPage() {
        if pageCount > 0 {
            currentPage = pageCount - 1
            desiredPage = "\(pageCount)"
        }
    }
    
    func sharePDF() {
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/image/get/\(id ?? 1)") else {
            return
        }
        let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
    }
    
    func savePDFToPhone() {
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/image/get/\(id ?? 1)") else {
            return
        }
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("\(name ?? "document").pdf")
        
        URLSession.shared.downloadTask(with: url) { location, response, error in
            guard let location = location, error == nil else {
                return
            }
            
            do {
                try FileManager.default.moveItem(at: location, to: fileURL)
                DispatchQueue.main.async {
                    self.fileURL = fileURL
                    self.alertMessage = "PDF başarıyla kaydedildi: \(fileURL.lastPathComponent)"
                    self.showAlert = true
                    print("PDF saved to: \(fileURL)")
                }
            } catch {
                self.alertMessage = "PDF kaydedilirken hata oluştu: \(error.localizedDescription)"
                self.showAlert = true
                print("Error saving PDF: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let pdfDocument: PDFDocument
    @Binding var currentPage: Int


    func makeUIView(context: Context) -> PDFView{
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        //pdfView.usePageViewController(true)
        pdfView.displayDirection = .vertical
        pdfView.backgroundColor = .white
        return pdfView
    }
    func updateUIView(_ uiView: PDFView, context: Context) {
        if let page = pdfDocument.page(at: currentPage) {
            uiView.go(to: page)
        }
    }
}

struct PDFViews_Previews: PreviewProvider {
    static var previews: some View {
        PDFViews(id: 59, name: "elma")
    }
}
