//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Оксана Аралина on 13.06.2024.
//

import UIKit

class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []
    private var roundMovies: [MostPopularMovie] = []
    private weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func setup(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            if roundMovies.isEmpty { roundMovies = movies }
            let index = (0..<self.roundMovies.count).randomElement() ?? 0
            
            guard let movie = self.roundMovies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.didFailToLoadNextQuestion(with: DataLoadError.failedToLoadImage)
                }
                return
            }
            
            let rating = Float(movie.rating) ?? 0
            let randomEstimate = (1...9).randomElement() ?? 1
            let isGreaterThan = Bool.random()
            let text: String
            let correctAnswer: Bool
            
            if isGreaterThan {
                text = "Рейтинг этого фильма больше чем \(randomEstimate)?"
                correctAnswer = rating > Float(randomEstimate)
            } else {
                text = "Рейтинг этого фильма меньше чем \(randomEstimate)?"
                correctAnswer = rating < Float(randomEstimate)
            }
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.roundMovies.remove(at: index)
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}

//    // массив вопросов
//    private let questions: [QuizQuestion] = [
//        QuizQuestion(
//            image: "The Godfather",
//            text: "Рейтинг этого фильма больше чем 7?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "The Dark Knight",
//            text: "Рейтинг этого фильма меньше чем 8?",
//            correctAnswer: false),
//        QuizQuestion(
//            image: "Kill Bill",
//            text: "Рейтинг этого фильма меньше чем 9?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "The Avengers",
//            text: "Рейтинг этого фильма больше чем 7?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "Deadpool",
//            text: "Рейтинг этого фильма меньше чем 6?",
//            correctAnswer: false),
//        QuizQuestion(
//            image: "The Green Knight",
//            text: "Рейтинг этого фильма больше чем 3?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "Old",
//            text: "Рейтинг этого фильма меньше чем 4?",
//            correctAnswer: false),
//        QuizQuestion(
//            image: "The Ice Age Adventures of Buck Wild",
//            text: "Рейтинг этого фильма больше чем 5?",
//            correctAnswer: false),
//        QuizQuestion(
//            image: "Tesla",
//            text: "Рейтинг этого фильма больше чем 2?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "Vivarium",
//            text: "Рейтинг этого фильма меньше чем 5?",
//            correctAnswer: false)
//    ]
