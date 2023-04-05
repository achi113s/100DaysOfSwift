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
    
    private var gradientTitle = UIView()
    private let gradientTitleWidth = 300
    private let gradientTitleHeight = 80
    
    @IBOutlet weak var lettersStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGradientTitle()
        NSLayoutConstraint.activate([
            gradientTitle.widthAnchor.constraint(equalToConstant: CGFloat(gradientTitleWidth)),
            gradientTitle.heightAnchor.constraint(equalToConstant: CGFloat(gradientTitleHeight)),
            gradientTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gradientTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)
        ])
        
        performSelector(inBackground: #selector(loadWords), with: nil)
    }
    
    @objc func loadWords() {
        if let wordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let wordsString = try? String(contentsOf: wordsURL) {
                words = wordsString.components(separatedBy: "\n")
                words.shuffle()
            }
        } else {
            words = ["Empty"]
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.startGame()
        }
    }
    
    func startGame() {
        currentWord = words[0]
        
        for _ in 0..<currentWord.count {
            let letter = UILabel()
            letter.text = "_"
            letter.font = UIFont.systemFont(ofSize: 20)
            letter.translatesAutoresizingMaskIntoConstraints = false
            letter.textColor = .black
            lettersStackView.addSubview(letter)
            print(letter.text)
        }
        lettersStackView.layer.borderColor = UIColor.black.cgColor
        lettersStackView.layer.borderWidth = 3
        self.view.addSubview(lettersStackView)
    }
    
    func createGradientTitle() {
        let gradientView = UIView(frame: CGRect(x: 0, y: 0, width: gradientTitleWidth, height: gradientTitleHeight))
        let gradient = CAGradientLayer()
        
        gradient.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
        
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        gradient.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradient)
        
        let label = UILabel(frame: gradientView.bounds)
        label.text = "HANGMAN"
        if let customFont = UIFont(name: "PermanentMarker-Regular", size: 50) {
            label.font = customFont
        } else {
            label.font = UIFont.systemFont(ofSize: 50)
        }
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        gradientView.addSubview(label)
        gradientView.mask = label
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        self.gradientTitle = gradientView
        
        self.view.addSubview(self.gradientTitle)
    }
    
}

