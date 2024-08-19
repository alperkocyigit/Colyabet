//
//  BarcodeViewModelTest.swift
//  ColyakAppTests
//
//  Created by Alper Koçyiğit on 9.07.2024.
//

import XCTest
@testable import ColyakApp

final class BarcodeViewModelTest: XCTestCase {
    
        lazy var session: URLSession = {
            let configuration = URLSessionConfiguration.ephemeral
            configuration.protocolClasses = [MockURLProtocol.self]
            return URLSession(configuration: configuration)
        }()

        lazy var api: BarcodeViewModel = {
            BarcodeViewModel(session: session)
        }()
    
    override func setUp() {
           super.setUp()
           // Token ayarını yapalım
            api.vm.saveTokenToUserDefaults(token: "mockedToken", refreshToken: "mockedRefreshToken", tokenExpiry: Date(), refreshTokenExpiry:Date())
       }


    override func tearDown() {
            MockURLProtocol.requestHandler = nil
           super.tearDown()
       }
    
    

    func testFetchAllBarcode_Success() async throws{
            // Arrange
            let mockData = """
            [
                {
                    "id": 0,
                    "code": 0,
                    "name": "string",
                    "imageId": 0,
                    "glutenFree": true,
                    "deleted": true,
                    "nutritionalValuesList": [
                      {
                        "id": 0,
                        "unit": 0,
                        "type": "string",
                        "carbohydrateAmount": 0,
                        "proteinAmount": 0,
                        "fatAmount": 0,
                        "calorieAmount": 0
                      }
                    ]
                  }
            ]
            """.data(using: .utf8)!
            
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.absoluteString,"https://api.colyakdiyabet.com.tr/api/barcodes/all")
            
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, mockData)
            
        }
            let expectation = XCTestExpectation(description: "Fetch all barcodes")
            api.fetchAllBarcode()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                XCTAssertFalse(self.api.allBarcodes.isEmpty, "The barcodes array should not be empty after fetching")
                XCTAssertEqual(self.api.allBarcodes.count, 1, "The barcodes array should contain 1 items")
                XCTAssertEqual(self.api.allBarcodes.first?.code, 0, "The first barcode code should be 0")
                expectation.fulfill()
            }
            
            await fulfillment(of: [expectation],timeout: 5.0)
        }
    
    func testFetchAllBarcode_Failure() async throws {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
        let expectation = XCTestExpectation(description: "Fetch all barcodes failure")
        api.fetchAllBarcode()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.api.allBarcodes.isEmpty, "The barcodes array should be empty after a failure")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation],timeout: 5.0)
      
    }
}

