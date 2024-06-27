//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Оксана Аралина on 13.06.2024.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func showAlert(_ result: AlertModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "Game Result"
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            result.completion()
        }
        
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
