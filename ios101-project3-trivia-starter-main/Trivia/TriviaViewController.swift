import Foundation
import UIKit

class TriviaViewController: UIViewController {
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var questionTypeLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!

    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!

    private var questionList = [Question]()
    private var selectedQuestionIndex = 0
    private var correctAnswerCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        questionList = setupQuestions()
        configure(with: questionList[selectedQuestionIndex])
    }

    private func configure(with question: Question) {
        questionNumberLabel.text = "Question: \(selectedQuestionIndex + 1)/3"
        questionTypeLabel.text = question.type.description
        
        questionLabel.text = question.text
        questionLabel.numberOfLines = 0
        questionLabel.lineBreakMode = .byWordWrapping

        answerButton1.setTitle(question.answers[0].text, for: .normal)
        answerButton2.setTitle(question.answers[1].text, for: .normal)
        answerButton3.setTitle(question.answers[2].text, for: .normal)
        answerButton4.setTitle(question.answers[3].text, for: .normal)

        resetButtonColors()
    }

    private func checkAndUpdateUI(selectedAnswerIndex: Int) {
        guard selectedQuestionIndex < questionList.count else {
            showResult()
            return
        }

        let currentQuestion = questionList[selectedQuestionIndex]
        guard selectedAnswerIndex < currentQuestion.answers.count else {
            print("Invalid selected answer index.")
            return
        }

        let selectedAnswer = currentQuestion.answers[selectedAnswerIndex]

        let answerButtons: [UIButton] = [answerButton1, answerButton2, answerButton3, answerButton4]

        for (index, answerButton) in answerButtons.enumerated() {

            if index == selectedAnswerIndex {
                correctAnswerCount += selectedAnswer.correct ? 1 : 0
            }
        }

        selectedQuestionIndex += 1
        if selectedQuestionIndex < questionList.count {
            configure(with: questionList[selectedQuestionIndex])
        } else {
            showResult()
        }
    }


    @IBAction func answerSelected(_ sender: UIButton) {
        let selectedAnswerIndex: Int
        switch sender {
        case answerButton1: selectedAnswerIndex = 0
        case answerButton2: selectedAnswerIndex = 1
        case answerButton3: selectedAnswerIndex = 2
        case answerButton4: selectedAnswerIndex = 3
        default: return
        }

        checkAndUpdateUI(selectedAnswerIndex: selectedAnswerIndex)
    }

    private func showResult() {
        let message = "Number of correct answers: \(correctAnswerCount)/3"
        let alertController = UIAlertController(title: "Results", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    private func resetButtonColors() {
        [answerButton1, answerButton2, answerButton3, answerButton4].forEach { $0?.backgroundColor = UIColor.darkGray }
    }

    private func setupQuestions() -> [Question] {
        let mockData1 = Question(type: .history, text: "When did Kazakhstan gain independence?", answers: [
            Answer(text: "1465", correct: false),
            Answer(text: "1986", correct: false),
            Answer(text: "1991", correct: true),
            Answer(text: "1993", correct: false)
        ])
        let mockData2 = Question(type: .music, text: "The most popular QPop band in KZ", answers: [
            Answer(text: "Alpha", correct: false),
            Answer(text: "Ninety One", correct: true),
            Answer(text: "Orda", correct: false),
            Answer(text: "DNA", correct: false)
        ])
        let mockData3 = Question(type: .film, text: "Kuka's last horror film", answers: [
            Answer(text: "Dastur", correct: true),
            Answer(text: "Otyzdan Asyp Baramyn", correct: false),
            Answer(text: "Qash", correct: false),
            Answer(text: "Dos-Mukasan", correct: false)
        ])
        return [mockData1, mockData2, mockData3]
    }
}

struct Question {
    let type: QuestionType
    let text: String
    let answers: [Answer]
}

enum QuestionType {
    case history
    case music
    case film

    var description: String {
        switch self {
        case .history:
            return "History"
        case .music:
            return "Entertainment: Music"
        case .film:
            return "Entertainment: Film"
        }
    }
}

struct Answer {
    let text: String
    let correct: Bool
}
