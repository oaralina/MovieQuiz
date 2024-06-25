//
//  DataLoadError.swift
//  MovieQuiz
//
//  Created by Оксана Аралина on 19.06.2024.
//

import Foundation

enum DataLoadError: Error, LocalizedError {
    case failedToLoadImage
    
    public var errorDescription: String? {
        switch self {
        case .failedToLoadImage:
            return NSLocalizedString("Не удалось загрузить следующий вопрос", comment: "Image not found")
        }
    }
}
