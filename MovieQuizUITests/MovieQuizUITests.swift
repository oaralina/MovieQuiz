//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Оксана Аралина on 24.06.2024.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
        
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testYesButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        
        app.buttons["Yes"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        
        app.buttons["Yes"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testCheckFinalAlert() {
        sleep(2)
        let yesButton = app.buttons["Yes"]
        let noButton = app.buttons["No"]
        
        for _ in 0..<10 {
            let randomButton = Bool.random() ? yesButton : noButton
            randomButton.tap()
            sleep(2)
            }
            
        let alert = app.alerts["Game Result"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть еще раз")
    }
    
    func testStartNewGame() {
        sleep(2)
        let yesButton = app.buttons["Yes"]
        let noButton = app.buttons["No"]
        
        for _ in 0..<10 {
            let randomButton = Bool.random() ? yesButton : noButton
            randomButton.tap()
            sleep(2)
            }
            
        let alert = app.alerts["Game Result"]
        alert.buttons.firstMatch.tap()
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertEqual(indexLabel.label, "1/10")
    }
        
        func testExample() throws {
            // UI tests must launch the application that they test.
            let app = XCUIApplication()
            app.launch()
            
            // Use XCTAssert and related functions to verify your tests produce the correct results.
        }
    }
