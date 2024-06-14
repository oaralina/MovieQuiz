//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Оксана Аралина on 13.06.2024.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    weak var delegate: QuestionFactoryDelegate?
    
    // массив вопросов
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 7?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма меньше чем 8?",
            correctAnswer: false),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма меньше чем 9?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 7?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма меньше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 3?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма меньше чем 4?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 5?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 2?",
            correctAnswer: true),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма меньше чем 5?",
            correctAnswer: false)
    ]
    
    //приватная переменная со списком вопросов для текущего раунда
    private var roundQuestions: [QuizQuestion] = []
    
    func requestNextQuestion() {
        //если массив вопросов пустой, то присваем ему значение массива questions
        if roundQuestions.isEmpty {roundQuestions = questions}
        guard let index = (0..<roundQuestions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }

        let question = roundQuestions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
        //удаляем полученный элемент из массива, чтобы вопросы не повторялись за время раунда
        roundQuestions.remove(at: index)
    }
}
