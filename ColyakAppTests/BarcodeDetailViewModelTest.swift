//
//  BarcodeDetailViewModelTest.swift
//  ColyakAppTests
//
//  Created by Alper Koçyiğit on 9.07.2024.
//

import XCTest
@testable import ColyakApp

final class BarcodeDetailViewModelTest: XCTestCase {
    
        lazy var session: URLSession = {
            let configuration = URLSessionConfiguration.ephemeral
            configuration.protocolClasses = [MockURLProtocol.self]
            return URLSession(configuration: configuration)
        }()

        lazy var api: BarcodeDetailsViewModel = {
            BarcodeDetailsViewModel(session: session)
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
                {
                    "id": 1,
                    "code": 0,
                    "name": "Test Barcode",
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
            """.data(using: .utf8)!
            
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.absoluteString,"https://api.colyakdiyabet.com.tr/api/barcodes/get/byId/1")
            
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, mockData)
            
        }
            let expectation = XCTestExpectation(description: "Fetch all detail barcodes")
            api.fetchDetailBarcode(byId: 1)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                XCTAssertEqual(self.api.selectedBarcodes?.name,"Test Barcode","The barcodes array should not be empty after fetching")
                XCTAssertEqual(self.api.selectedBarcodes?.code, 0, "The first barcode code should be 0")
                expectation.fulfill()
            }
            
            await fulfillment(of: [expectation],timeout: 2.0)
        }
    
    func testFetchDetailBarcode_Failure() async throws{
            // Arrange
            MockURLProtocol.requestHandler = { request in
                let response = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: nil, headerFields: nil)!
                return (response, Data())
            }

            // Test
            let expectation = XCTestExpectation(description: "Fetch detail barcode handles failure")
            api.fetchDetailBarcode(byId: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                XCTAssertNil(self.api.selectedBarcodes, "The selectedBarcode should be nil when the request fails")
                expectation.fulfill()
            }
        await fulfillment(of: [expectation],timeout: 2.0)
        }
    
    func testBarcodeCodeSearch_Success() async throws{

        let mockData = """
            {
                "id": 1,
                "code": 123456,
                "name": "Test Barcode",
                "imageId": 0,
                "glutenFree": true,
                "deleted": false,
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
        """.data(using: .utf8)!
            
            MockURLProtocol.requestHandler = { request in
                XCTAssertEqual(request.url?.absoluteString, "https://api.colyakdiyabet.com.tr/api/barcodes/code/testcode")
                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                return (response, mockData)
            }

            // Test
            let expectation = XCTestExpectation(description: "Barcode code search succeeds")
            api.barcodeCodeSearch(by: "testcode")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                XCTAssertEqual(self.api.selectedBarcodes?.name,"Test Barcode","The barcodes array should not be empty after fetching")
                XCTAssertTrue(self.api.isFound ?? false, "The barcode should be found")
                XCTAssertEqual(self.api.selectedBarcodes?.code, 123456, "The barcode code should be 123456")
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 2.0)
        }
}

