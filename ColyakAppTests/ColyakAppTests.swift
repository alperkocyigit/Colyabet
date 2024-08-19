//
//  ColyakAppTests.swift
//  ColyakAppTests
//
//  Created by Alper Koçyiğit on 9.07.2024.
//

import XCTest
@testable import ColyakApp

final class ColyakAppTests: XCTestCase {

    var viewModel: LoginViewModel!

    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel()
        // Clear UserDefaults before each test
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "tokenExpiry")
        UserDefaults.standard.removeObject(forKey: "refreshTokenExpiry")
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testSaveAndGetUsernameToUserDefaults() {
        let username = "testUser"
        viewModel.saveUsernameToUserDefaults(userName: username)
        let savedUsername = viewModel.getUsernameUserDefaults()
        XCTAssertEqual(savedUsername, username, "The saved username should match the retrieved username")
    }

    func testSaveAndGetEmailToUserDefaults() {
        let email = "test@example.com"
        viewModel.saveEmailToUserDefaults(email: email)
        let savedEmail = viewModel.getEmailFromUserDefaults()
        XCTAssertEqual(savedEmail, email, "The saved email should match the retrieved email")
    }

    func testSaveAndGetTokenToUserDefaults() {
        let token = "testAccessToken"
        let refreshToken = "testRefreshToken"
        let tokenExpiry = Date().addingTimeInterval(3600)
        let refreshTokenExpiry = Date().addingTimeInterval(7200)
        viewModel.saveTokenToUserDefaults(
            token: token,
            refreshToken: refreshToken,
            tokenExpiry: tokenExpiry,
            refreshTokenExpiry: refreshTokenExpiry
        )

        XCTAssertEqual(viewModel.getTokenFromUserDefaults(), token, "The saved access token should match the retrieved access token")
        XCTAssertEqual(viewModel.getRefreshTokenFromUserDefaults(), refreshToken, "The saved refresh token should match the retrieved refresh token")
        XCTAssertEqual(viewModel.getTokenExpiryFromUserDefaults(), tokenExpiry, "The saved token expiry should match the retrieved token expiry")
        XCTAssertEqual(viewModel.getRefreshTokenExpiryFromUserDefaults(), refreshTokenExpiry, "The saved refresh token expiry should match the retrieved refresh token expiry")
    }

    func testCheckLoginStatusWithValidToken() {
        // Arrange
        let token = "testAccessToken"
        let refreshToken = "testRefreshToken"
        let tokenExpiry = Date().addingTimeInterval(3600)
        let refreshTokenExpiry = Date().addingTimeInterval(7200)
        viewModel.saveTokenToUserDefaults(
            token: token,
            refreshToken: refreshToken,
            tokenExpiry: tokenExpiry,
            refreshTokenExpiry: refreshTokenExpiry
        )
        viewModel.accessToken = token
        viewModel.refreshToken = refreshToken

        let expectation = XCTestExpectation(description: "Check login status with valid token")
        viewModel.checkLoginStatus()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.viewModel.isLoggedIn, "User should be logged in with a valid token")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
    
    func testClearToken() {

        let initialToken = "testAccessToken"
        let initialRefreshToken = "testRefreshToken"
        let initialEmail = "test@example.com"
        let initialPassword = "testPassword"
        

        viewModel.accessToken = initialToken
        viewModel.refreshToken = initialRefreshToken
        viewModel.email = initialEmail
        viewModel.passwordd = initialPassword
        
        UserDefaults.standard.set(initialToken, forKey: "accessToken")
        UserDefaults.standard.set(initialRefreshToken, forKey: "refreshToken")
        UserDefaults.standard.set(initialEmail, forKey: "userEmail")
        UserDefaults.standard.set("testUserName", forKey: "userName")
        
        viewModel.clearToken()
        
        
        XCTAssertEqual(viewModel.accessToken, "", "accessToken should be cleared")
        XCTAssertEqual(viewModel.refreshToken, "", "refreshToken should be cleared")
        XCTAssertEqual(viewModel.email, "", "email should be cleared")
        XCTAssertEqual(viewModel.passwordd, "", "passwordd should be cleared")
  
        
        XCTAssertNil(UserDefaults.standard.string(forKey: "accessToken"), "accessToken should be removed from UserDefaults")
        XCTAssertNil(UserDefaults.standard.string(forKey: "refreshToken"), "refreshToken should be removed from UserDefaults")
        XCTAssertNil(UserDefaults.standard.string(forKey: "userEmail"), "userEmail should be removed from UserDefaults")
        XCTAssertNil(UserDefaults.standard.string(forKey: "userName"), "userName should be removed from UserDefaults")
    }
}
