//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Оксана Аралина on 13.06.2024.
//

import Foundation

final class StatisticServiceImplementation: StatisticServiceProtocol {
    private enum Keys: String {
        case correct
        case total
        case bestGame
        case gamesCount
    }
    
    private var correctAnswer: Int = 0
    private let storage: UserDefaults = .standard
    
    var correct: Int {
        get {storage.integer(forKey: Keys.correct.rawValue)}
        
        set {storage.set(newValue, forKey: Keys.correct.rawValue)}
    }
    
    
    var total: Int {
        get {storage.integer(forKey: Keys.total.rawValue)}
        
        set {storage.set(newValue, forKey: Keys.total.rawValue)}
    }
    
    var gamesCount: Int {
        get {storage.integer(forKey: Keys.gamesCount.rawValue)}
        set {storage.set(newValue, forKey: Keys.gamesCount.rawValue)}
    }
    
    var bestGame: GameResult{
        get {
            guard let data = storage.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameResult.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        } set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            storage.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        guard gamesCount != 0 else { return 0.0 }
        return (Double(correct) / Double(gamesCount)) * 10.0
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        correct += count
        total += amount
        
        let gameResult = GameResult(correct: count, total: amount, date: Date())
        
        if gameResult.isBetterThan(bestGame) {
            bestGame = gameResult
        }
    }
}
