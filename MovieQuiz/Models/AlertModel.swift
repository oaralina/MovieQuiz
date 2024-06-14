//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Оксана Аралина on 13.06.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let text: String
    let buttonText: String
    let completion: () -> Void
}
