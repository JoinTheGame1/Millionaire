//
//  Extensions.swift
//  Millionaire
//
//  Created by Никитка on 06.12.2021.
//

import Foundation
import UIKit

extension UIViewController {
    func displayOkAlert(title: String, message: String, _ completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: completion)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func displayYesNoAlert(title: String, message: String, _ completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: completion)
        let noAction = UIAlertAction(title: "Nope", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
}

extension UIColor {
    static var unanswered: UIColor { return .systemIndigo }
    static var answered: UIColor { return .systemOrange }
    static var correct: UIColor { return .systemGreen }
    static var incorrect: UIColor { return .systemRed }
}

extension Int {
    var formatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        let number = NSNumber(value: self)
        let formattedValue = formatter.string(from: number)
        return "\(formattedValue ?? "")"
    }
    
    static func random(in range: ClosedRange<Int>, excluding x: Int) -> Int {
        
        if range.contains(x) {
            let r = Int.random(in: Range(uncheckedBounds: (range.lowerBound, range.upperBound)))
            return r == x ? range.upperBound : r
        } else {
            return Int.random(in: range)
        }
    }
}

extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}

func delay(competion: @escaping () -> ()) {
    let game = Game.shared
    let when = DispatchTime.now() + game.delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: competion)
}
