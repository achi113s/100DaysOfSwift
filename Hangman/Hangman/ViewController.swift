//
//  ViewController.swift
//  Hangman
//
//  Created by Giorgio Latour on 4/4/23.
//

import UIKit

class ViewController: UIViewController {
    
    private var promptWordLabel: UILabel!
    private var scoreLabel: UILabel!
    private var gradientTitle: UIView!
    private var inputStackView: UIStackView!
    private var inputTextField: UITextField!
    private var submitButton: UIButton!
    
    private let gradientTitleWidth = 300
    private let gradientTitleHeight = 80
    
    private var words: [String] = [String]()
    private var word: String = ""
    private var promptWord: String = "" {
        didSet {
            promptWordLabel.text = promptWord
        }
    }
    private var lettersUsed: [String] = [String]()
    private var wrongGuesses: Int = 0 {
        didSet {
            scoreLabel.text = String("\(wrongGuesses) Wrong Guesses")
        }
    }
    
    override func loadView() {
        super.loadView()
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.cgColor, UIColor.white.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
        
        createGradientTitle()
        
        promptWordLabel = UILabel()
        promptWordLabel.translatesAutoresizingMaskIntoConstraints = false
        promptWordLabel.font = UIFont.systemFont(ofSize: 36)
        promptWordLabel.text = "_"
        promptWordLabel.textAlignment = .center
        promptWordLabel.numberOfLines = 0
        view.addSubview(promptWordLabel)
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.font = UIFont.systemFont(ofSize: 40)
        scoreLabel.text = "0"
        scoreLabel.textAlignment = .center
        scoreLabel.numberOfLines = 0
        view.addSubview(scoreLabel)
        
        submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("Submit Letter", for: .normal)
        submitButton.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
        submitButton.addTarget(self, action: #selector(promptForAnswer), for: .touchUpInside)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            gradientTitle.widthAnchor.constraint(equalToConstant: CGFloat(gradientTitleWidth)),
            gradientTitle.heightAnchor.constraint(equalToConstant: CGFloat(gradientTitleHeight)),
            gradientTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gradientTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scoreLabel.topAnchor.constraint(equalTo: gradientTitle.bottomAnchor, constant: 30),
            
            promptWordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            promptWordLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            promptWordLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.topAnchor.constraint(equalTo: promptWordLabel.bottomAnchor, constant: 50)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(loadWords), with: nil)
    }
    
    @objc func loadWords() {
        if let wordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let wordsString = try? String(contentsOf: wordsURL) {
                words = wordsString.components(separatedBy: "\n")
            }
        } else {
            words = ["Empty"]
        }
        startLevel()
    }
    
    func startLevel() {
        DispatchQueue.main.async { [weak self] in
            self?.words.shuffle()
            self?.word = self?.words.first ?? "Empty"
            self?.setPromptWord()
        }
    }
    
    @objc func promptForAnswer(_ sender: UIButton) {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            if answer.count == 1 {
                self?.submit(answer)
            }
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        lettersUsed.append(answer.uppercased())
        
        if word.contains(answer) {
            setPromptWord()
        } else {
            wrongGuesses += 1
            print("not in \(word)")
        }
    }
    
    func setPromptWord() {
        promptWord = ""
        for letter in word {
            let strLetter = String(letter)
            if lettersUsed.contains(strLetter) {
                promptWord += strLetter
            } else {
                promptWord += "?"
            }
        }
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

