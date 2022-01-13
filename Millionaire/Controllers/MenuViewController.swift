//
//  MenuViewController.swift
//  Millionaire
//
//  Created by Никитка on 04.12.2021.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet var menuView: UIView!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var resultsButton: UIButton!
    @IBOutlet weak var lastResultLabel: UILabel!
    
    let game = Game.shared
    let statisticsService = StatisticsService()
    let gameSessionCaretaker = GameSessionCaretaker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupGradientBackground()
        setupOther()
        
        if game.gameSession == nil { lastResultLabel.text = "" }
        if let lastStats = statisticsService.fetchLast() {
            lastResultLabel.text = lastStats.text.uppercased()
        }
        if let _ = gameSessionCaretaker.load() {
            self.displayYesNoAlert(title: "OOPS...", message: "Download last game?") { _ in
                self.performSegue(withIdentifier: "toGameVC", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGameVC" {
            let destination = segue.destination as! GameViewController
            destination.gameDelegate = self
            
            if let abortedGame = gameSessionCaretaker.load() {
                destination.abortedGame = abortedGame
            }
        }
    }
    
    private func setupGradientBackground() {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 0.506, green: 0.796, blue: 0.827, alpha: 1).cgColor,
            UIColor(red: 0.397, green: 0.642, blue: 0.749, alpha: 1).cgColor,
            UIColor(red: 0.26, green: 0.449, blue: 0.649, alpha: 1).cgColor,
            UIColor(red: 0.094, green: 0.216, blue: 0.529, alpha: 1).cgColor,
            UIColor(red: 0.071, green: 0.055, blue: 0.106, alpha: 1).cgColor
        ]
        layer.locations = [0, 0.06, 0.29, 0.54, 0.98]
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1.05, b: 1.02, c: -1.02, d: 0.22, tx: 0.52, ty: -0.12))
        layer.bounds = view.bounds.insetBy(dx: -0.5*menuView.bounds.size.width, dy: -0.5*menuView.bounds.size.height)
        layer.position = menuView.center
        menuView.layer.insertSublayer(layer, at: 0)
    }
    
    private func setupOther() {
        startGameButton.layer.backgroundColor = UIColor(red: 0.349, green: 0.541, blue: 0.702, alpha: 1).cgColor
        startGameButton.layer.cornerRadius = 19
        startGameButton.layer.borderWidth = 1
        startGameButton.layer.borderColor = UIColor(red: 0.486, green: 0.769, blue: 0.816, alpha: 1).cgColor
        startGameButton.setTitleColor(UIColor(red: 0.086, green: 0.145, blue: 0.345, alpha: 1),
                                      for: .normal)
        resultsButton.layer.backgroundColor = UIColor(red: 0.349, green: 0.541, blue: 0.702, alpha: 1).cgColor
        resultsButton.layer.cornerRadius = 16
        resultsButton.layer.borderWidth = 1
        resultsButton.layer.borderColor = UIColor(red: 0.486, green: 0.769, blue: 0.816, alpha: 1).cgColor
        resultsButton.setTitleColor(UIColor(red: 0.086, green: 0.145, blue: 0.345, alpha: 1),
                                    for: .normal)
        lastResultLabel.textColor = .white
    }
}

extension MenuViewController: GameViewControllerDelegate {
    func didEndGame(with result: GameSession) {
        game.gameSession = result
        
        let data = GameStatistics()
        data.correctAnswersCount = game.currentQuestionIndex
        data.percentage = game.percentage
        data.isFiftyFiftyUsed = game.gameSession?.isFiftyFiftyUsed ?? false
        data.isAskAudienceUsed = game.gameSession?.isAskAudienceUsed ?? false
        data.isPhoneUsed = game.gameSession?.isPhoneUsed ?? false
        data.totalMoneyWon = game.totalMoneyWon
        data.gameStatus = game.gameStatus
        data.date = String(describing: NSDate.now)
        if game.gameSession?.gameStatus == .lost {
            let currentQuestion = game.gameSession?.currentQuestion
            data.fatalQuestion = currentQuestion?.text
            let correctAnswerIndex = currentQuestion?.correctAnswerIndex ?? 0
            data.correctAnswerForFatal = currentQuestion?.answers[correctAnswerIndex].text
        }
        
        statisticsService.add(data)
        game.gameSession = nil
        gameSessionCaretaker.delete()
        lastResultLabel.text = data.text.uppercased()
    }
}
