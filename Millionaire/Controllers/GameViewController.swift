//
//  GameViewController.swift
//  Millionaire
//
//  Created by Никитка on 05.12.2021.
//

import Foundation
import UIKit

protocol GameViewControllerDelegate: AnyObject {
    func didEndGame(with result: GameSession)
}

class GameViewController: UIViewController {
    
    @IBOutlet weak var askTheAudienceButton: UIButton!
    @IBOutlet weak var fiftyFiftyButton: UIButton!
    @IBOutlet weak var phoneAfriendButton: UIButton!
    @IBOutlet weak var endGameButton: UIButton!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionValueLabel: UILabel!
    
    @IBOutlet weak var answerA: UIButton!
    @IBOutlet weak var answerB: UIButton!
    @IBOutlet weak var answerC: UIButton!
    @IBOutlet weak var answerD: UIButton!
    lazy var answerButtons = [answerA, answerB, answerC, answerD]
    
    weak var gameDelegate: GameViewControllerDelegate?
    let game = Game.shared
    let gameSession = GameSession()
    let qnaProvider = QnAProvider()
    let gameSessionCaretaker = GameSessionCaretaker()
    var abortedGame: GamePersisted?
    
    let askAudienceTitle = "Ask the Audience"
    let askAudienceMessage = "Most believers think that the correct answer - "
    
    let phoneAfriendTitle = "Phone a Friend"
    let phoneAfriendMessage = "Sorry, bruh, I'm not sure, but I think that the correct answer is "
    
    let endGameTitle = "End the game?"
    lazy var endGameMessage = """
        Are you sure you want to end the game?
        Your winnings will be \(self.gameSession.earnedMoney.formatted) ₽
        """
    
    let gameOverTitle = "Here we go again..."
    var gameOverMoney: Int {
        let money = self.gameSession.guaranteedEarnedMoney
        return money > 0 ? money : 0
    }
    lazy var gameOverMessage = """
        The answer is incorrect.
        Your winnings are \(self.gameOverMoney) ₽.
        Game over.
        """
    
    let winTitle = "CONGRATULATIONS?"
    lazy var winMessage = """
        Congratulations, we took all our cash.
        Okay, we'll collect a new amount for the next game.
        Take your money, lucky!
        """
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        if abortedGame != nil {
            restoreGameSession()
        } else {
            resetGameSession()
        }
        
        setupButtons()
        displayQuestion()
    }
    
    private func setupButtons() {
        for button in self.answerButtons {
            button?.layer.cornerRadius = 5
            button?.tintColor = .black
            button?.addTarget(self, action: #selector(answerButtonAction), for: .touchUpInside)
        }
    }
    
    private func restoreGameSession() {
        guard let abortedGame = abortedGame else { return }
        gameSession.currentQuestionNumber = abortedGame.currentQuestionNumber
        gameSession.isFiftyFiftyUsed = abortedGame.isFiftyFiftyUsed
        gameSession.isPhoneUsed = abortedGame.isPhoneUsed
        gameSession.isAskAudienceUsed = abortedGame.isAskAudienceUsed
        gameSession.gameStatus = .inProgress
    }
    
    private func resetGameSession() {
        gameSession.currentQuestionNumber = 1
        gameSession.isFiftyFiftyUsed = false
        gameSession.isPhoneUsed = false
        gameSession.isAskAudienceUsed = false
        gameSession.gameStatus = .inProgress
    }
    
    @objc func answerButtonAction(_ sender: UIButton!) {
        let answerIndex = sender.tag
        disableButtons(answerIndex)
        answerButtons[answerIndex]?.backgroundColor = .answered
        delay { [self] in
            if isCorrect(answerIndex) {
                answerButtons[answerIndex]?.backgroundColor = .correct
                delay {
                    if gameSession.currentQuestionNumber < game.totalQuestions {
                        nextQuestion()
                    } else {
                        win(answerIndex)
                    }
                }
            } else {
                gameOver(answerIndex)
            }
        }
    }
    
    private func disableButtons(_ answerIndex: Int) {
        askTheAudienceButton.isEnabled = false
        askTheAudienceButton.alpha = 0.5
        
        fiftyFiftyButton.isEnabled = false
        fiftyFiftyButton.alpha = 0.5
        
        phoneAfriendButton.isEnabled = false
        phoneAfriendButton.alpha = 0.5
        
        endGameButton.isEnabled = false
        endGameButton.alpha = 0.5
        
        for button in answerButtons {
            button?.isEnabled = false
            button?.alpha = button?.tag != answerIndex ? 0.75 : 1
        }
    }
    
    private func isCorrect(_ answerIndex: Int) -> Bool {
        let answer = self.gameSession.currentQuestion?.answers[answerIndex]
        return answer?.correct ?? false
    }
    
    private func nextQuestion() {
        gameSession.currentQuestionNumber += 1
        displayQuestion()
        gameSessionCaretaker.save(gameSession)
    }
    
    private func displayQuestion() {
        let difficulty = gameSession.currentQuestionNumber
        updateButtons()
        guard let question = qnaProvider.fetchRandomQuestion(for: difficulty),
              let questionValue = game.payout[difficulty]
        else { return }
        self.questionValueLabel.text = "\(questionValue.formatted) ₽"
        self.questionLabel.text = question.text
        
        for (index, answer) in question.answers.enumerated() {
            answerButtons[index]?.setTitle(answer.text, for: .normal)
            answerButtons[index]?.backgroundColor = .unanswered
            answerButtons[index]?.alpha = 1.0
            answerButtons[index]?.isEnabled = true
            answerButtons[index]?.isHidden = false
        }
        gameSession.currentQuestion = question
    }
    
    private func updateButtons() {
        if gameSession.isFiftyFiftyUsed {
            fiftyFiftyButton.isEnabled = false
            fiftyFiftyButton.alpha = 0.75
        } else {
            fiftyFiftyButton.isEnabled = true
            fiftyFiftyButton.alpha = 1.0
        }
        
        if gameSession.isPhoneUsed {
            phoneAfriendButton.isEnabled = false
            phoneAfriendButton.alpha = 0.75
        } else {
            phoneAfriendButton.isEnabled = true
            phoneAfriendButton.alpha = 1.0
        }
        
        if gameSession.isAskAudienceUsed {
            askTheAudienceButton.isEnabled = false
            askTheAudienceButton.alpha = 0.75
        } else {
            askTheAudienceButton.isEnabled = true
            askTheAudienceButton.alpha = 1.0
        }
        
        if gameSession.earnedMoney == 0 {
            endGameButton.isEnabled = false
            endGameButton.alpha = 0.75
        } else {
            endGameButton.isEnabled = true
            endGameButton.alpha = 1.0
        }
    }
    
    private func win(_ answerIndex: Int) {
        answerButtons[answerIndex]?.backgroundColor = .correct
        answerButtons[answerIndex]?.alpha = 1.0
        gameSession.gameStatus = .won
        
        delay { [self] in
            displayOkAlert(title: winTitle, message: winMessage) { _ in
                self.endGame(self.gameSession)
            }
        }
    }
    
    private func endGame(_ session: GameSession) {
        gameDelegate?.didEndGame(with: session)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func gameOver(_ answerIndex: Int) {
        answerButtons[answerIndex]?.backgroundColor = .incorrect
        answerButtons[gameSession.currentQuestion!.correctAnswerIndex]?.backgroundColor = .correct
        answerButtons[gameSession.currentQuestion!.correctAnswerIndex]?.alpha = 1.0
        gameSession.gameStatus = .lost
        delay { [self] in
            displayOkAlert(title: gameOverTitle, message: gameOverMessage) { _ in
                self.endGame(self.gameSession)
            }
        }
    }
    
    @IBAction func askTheAudienceButtonPressed(_ sender: UIButton) {
        guard let firstIndex = gameSession.currentQuestion?.correctAnswerIndex else { return }
        let secondIndex = Int.random(in: 0...3, excluding: firstIndex)
        
        var audienceSuggests = 0
        
        if gameSession.isFiftyFiftyUsed { audienceSuggests = firstIndex } else {
            audienceSuggests = Int.random(in: 0...1) == 1 ? firstIndex : secondIndex
        }
        
        askTheAudienceButton.isEnabled = false
        askTheAudienceButton.alpha = 0.75
        gameSession.isAskAudienceUsed = true
        
        let answer = game.letterForAnswerIndex[audienceSuggests] ?? "Х/З"
        let answerText = gameSession.currentQuestion?.answers[audienceSuggests].text ?? "Х/3"
        
        delay { [self] in
            displayOkAlert(title: askAudienceTitle, message: askAudienceMessage + "\(answer) - '\(answerText)'.")
        }
    }
    
    @IBAction func fiftyFiftyButtonPressed(_ sender: UIButton) {
        guard let firstIndex = gameSession.currentQuestion?.correctAnswerIndex else { return }
        let secondIndex = Int.random(in: 0...3, excluding: firstIndex)
        
        fiftyFiftyButton.isEnabled = false
        fiftyFiftyButton.alpha = 0.75
        gameSession.isFiftyFiftyUsed = true
        
        for button in answerButtons {
            if button?.tag != firstIndex && button?.tag != secondIndex {
                button?.isEnabled = false
                button?.isHidden = true
            }
        }
    }
    
    @IBAction func phoneAfriendButtonPressed(_ sender: UIButton) {
        guard let firstIndex = gameSession.currentQuestion?.correctAnswerIndex else { return }
        let secondIndex = Int.random(in: 0...3, excluding: firstIndex)
        
        var friendSuggests = 0
        
        if gameSession.isFiftyFiftyUsed { friendSuggests = firstIndex } else {
            friendSuggests = Int.random(in: 0...1) == 1 ? firstIndex : secondIndex
        }
        
        phoneAfriendButton.isEnabled = false
        phoneAfriendButton.alpha = 0.75
        gameSession.isPhoneUsed = true
        
        let answer = game.letterForAnswerIndex[friendSuggests] ?? "Х/З"
        let answerText = gameSession.currentQuestion?.answers[friendSuggests].text ?? "Х/3"
        
        delay { [self] in
            displayOkAlert(title: phoneAfriendTitle,
                         message: phoneAfriendMessage + "\(answer) - '\(answerText)'.")
        }
    }
    
    @IBAction func endGameButtonPressed(_ sender: UIButton) {
        displayYesNoAlert(title: endGameTitle, message: endGameMessage) { _ in
            self.gameSession.gameStatus = .aborted
            self.endGame(self.gameSession)
        }
    }
}
