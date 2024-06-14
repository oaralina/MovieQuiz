//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Оксана Аралина on 13.06.2024.
//

import UIKit

class AlertPresenter: MovieQuizViewControllerDelelegate {
    weak var alertController: AlertPresenterProtocol?
    
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.text,
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Game Result"
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.completion()
        }
        
        alert.addAction(action)
        alertController?.present(alert, animated: true)
    }
}
