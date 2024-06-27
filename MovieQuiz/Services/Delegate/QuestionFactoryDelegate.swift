//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Оксана Аралина on 13.06.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
    func didFailToLoadNextQuestion(with error: Error)
}
