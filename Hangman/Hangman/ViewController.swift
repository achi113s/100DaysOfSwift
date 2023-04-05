//
//  ViewController.swift
//  Hangman
//
//  Created by Giorgio Latour on 4/4/23.
//

import UIKit

class ViewController: UIViewController {
    
    private var words: [String] = [String]()
    private var currentWord: String = ""
    private var currentWordIndex: Int = 0

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        assignFontToTitle()
        
        performSelector(inBackground: #selector(loadWords), with: nil)
    }

    @objc func loadWords() {
        if let wordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let wordsString = try? String(contentsOf: wordsURL) {
                words = wordsString.components(separatedBy: "\n")
            }
        }
        
        if words.isEmpty {
            words = ["Empty"]
        }
    }
    
    func startGame() {
        currentWordIndex = Int.random(in: 0..<words.count)
        
        currentWord = words[currentWordIndex]
    }
    
    func assignFontToTitle() {
        if let customFont = UIFont(name: "PermanentMarker-Regular", size: 40) {
            titleLabel.font = customFont
        }
        
        let gradientView = UIView(frame: titleLabel.frame)
        let gradient = CAGradientLayer()
        
        gradient.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
        
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        gradient.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradient)
        
        gradientView.addSubview(titleLabel)
//        gradientView.mask = titleLabel
        
        self.view.addSubview(gradientView)
    }

}

