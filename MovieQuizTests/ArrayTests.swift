//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Оксана Аралина on 24.06.2024.
//
import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        //Given
        let array = [1, 1, 2, 3, 5]
        
        //When
        let value = array[safe: 2]
        
        //Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutOfRange() throws {
        //Given
        let array = [1, 2, 3, 4, 5]
        
        //When
        let value = array[safe: 20]
        
        //Then
        XCTAssertNil(value)
    }
    
}
