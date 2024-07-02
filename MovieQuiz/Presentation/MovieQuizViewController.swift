import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - IB Outlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var counterLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var noButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var UIActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenterProtocol?
    
    // MARK: - Navigation
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIElementsHidden(true)
        setupUI()
        
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter(viewController: self)
        
        showLoadingIndicator()
    }
    
    private func setupUI() {
        titleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
    }
    
    // MARK: - IB Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    // MARK: - Private Methods
    func setUIElementsHidden(_ hidden: Bool) {
        titleLabel.isHidden = hidden
        counterLabel.isHidden = hidden
        imageView.isHidden = hidden
        questionLabel.isHidden = hidden
        yesButton.isHidden = hidden
        noButton.isHidden = hidden
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.color = UIColor.gray
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showResultAlert(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        
        let alertModel = AlertModel(title: result.title, text: message, buttonText: result.buttonText) { [weak self] in
            guard let self = self else { return }
            
            presenter.restartGame()
        }
        
        alertPresenter?.showAlert(alertModel)
    }
    
    func showNetworkError(text: String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка",
                               text: text,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self else { return }
            
            showLoadingIndicator()
            self.presenter.reloadData()
        }
        alertPresenter?.showAlert(model)
    }
    
    func showImageLoadError(text: String) {
        let model = AlertModel(title: "Ошибка",
                               text: text,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self else { return }
            
            showLoadingIndicator()
            presenter.requestNextQuestion()
        }
        alertPresenter?.showAlert(model)
    }
    
    // метод вывода на экран вопроса
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        questionLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // метод, который изменяет состояние доступности кнопок "Да" и "Нет"
    func changeButtonsState(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
        yesButton.backgroundColor = isEnabled ? UIColor.ypWhite : UIColor.gray
        noButton.backgroundColor = isEnabled ? UIColor.ypWhite : UIColor.gray
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.imageView.layer.borderWidth = 0
        }
    }
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 7?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма меньше чем 8?
 Ответ: НЕТ
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма меньше чем 9?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 7?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма меньше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 3?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма меньше чем 4?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 5?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 2?
 Ответ: ДА
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма меньше чем 5?
 Ответ: НЕТ
 */
