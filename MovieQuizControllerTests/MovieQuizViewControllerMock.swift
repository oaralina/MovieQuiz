//
//  MovieQuizViewControllerMock.swift
//  MovieQuizControllerTests
//
//  Created by Оксана Аралина on 26.06.2024.
//

import Foundation

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func setUIElementsHidden(_ hidden: Bool) {}
    
    func changeButtonsState(isEnabled: Bool) {}
    
    func showImageLoadError(text: String) {}
    
    func showResultAlert(quiz result: MovieQuiz.QuizResultsViewModel) {}
    
    func show(quiz step: QuizStepViewModel) {}
    
    func highlightImageBorder(isCorrectAnswer: Bool) {}
    
    func showLoadingIndicator() {}
    
    func hideLoadingIndicator() {}
    
    func showNetworkError(text: String) {}
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
