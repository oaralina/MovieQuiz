//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Оксана Аралина on 26.06.2024.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showResultAlert(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    func setUIElementsHidden(_ hidden: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func changeButtonsState(isEnabled: Bool)
    
    func showNetworkError(text: String)
    func showImageLoadError(text: String)
}
