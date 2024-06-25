import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterProtocol {
    
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
    private let presenter = MovieQuizPresenter()
    private var correctAnswers = 0
    private var alertPresenter: MovieQuizViewControllerDelelegate?
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticServiceProtocol?
    
    // MARK: - Navigation
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIElementsHidden(true)
        
        titleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        let alertPresenter = AlertPresenter()
        alertPresenter.alertController = self
        self.alertPresenter = alertPresenter
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        statisticService = StatisticServiceImplementation()
        
        showLoadingIndicator()
    }
    
    // MARK: - IB Actions
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    
    @IBAction func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.hideLoadingIndicator()
            self?.setUIElementsHidden(false)
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(text: error.localizedDescription)
    }
    
    func didFailToLoadNextQuestion(with error: Error) {
        showImageLoadError(text: error.localizedDescription)
    }
    
    // MARK: - AlertPresenterProtocol
    func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            statisticService?.store(correct: correctAnswers, total: presenter.questionsAmount)
            let text = """
            Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
            Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0)
            Рекорд: \(statisticService?.bestGame.correct ?? 0)/\(presenter.questionsAmount) (\(String(describing: statisticService?.bestGame.date.dateTimeString ?? "")))
            Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? ""))%
            """
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть еще раз",
                completion: {
                    self.showLoadingIndicator()
                    self.presenter.resetQuestionIndex()
                    self.correctAnswers = 0
                    self.questionFactory?.requestNextQuestion()
                }
            )
            alertPresenter?.show(alertModel: alertModel)
            correctAnswers = 0
        } else {
            showLoadingIndicator()
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    // MARK: - Private Methods
    private func setUIElementsHidden(_ hidden: Bool) {
        titleLabel.isHidden = hidden
        counterLabel.isHidden = hidden
        imageView.isHidden = hidden
        questionLabel.isHidden = hidden
        yesButton.isHidden = hidden
        noButton.isHidden = hidden
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.color = UIColor.gray
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    private func showNetworkError(text: String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка",
                               text: text,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self else { return }
            
            showLoadingIndicator()
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            self.questionFactory?.loadData()
        }
        alertPresenter?.show(alertModel: model)
    }
    
    private func showImageLoadError(text: String) {
        let model = AlertModel(title: "Ошибка",
                               text: text,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self else { return }
            
            showLoadingIndicator()
            self.questionFactory?.requestNextQuestion()
        }
        alertPresenter?.show(alertModel: model)
    }
    
    // приватный метод вывода на экран вопроса
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        questionLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // приватный метод, который изменяет состояние доступности кнопок "Да" и "Нет"
    private func changeButtonsState(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
        yesButton.backgroundColor = isEnabled ? UIColor.ypWhite : UIColor.gray
        noButton.backgroundColor = isEnabled ? UIColor.ypWhite : UIColor.gray
    }
    
    // приватный метод, который обрабатывает результат ответа
    private func showAnswerResult(isCorrect: Bool) {
        changeButtonsState(isEnabled: false)
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
            self.changeButtonsState(isEnabled: true)
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
