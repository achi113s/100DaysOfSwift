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
    private var gradientTitleView: UIView!
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
        
        gradientTitleView = createGradientLabel(withText: "HANGMAN")
        view.addSubview(gradientTitleView)
        
        promptWordLabel = UILabel()
        promptWordLabel.translatesAutoresizingMaskIntoConstraints = false
        promptWordLabel.font = UIFont.systemFont(ofSize: 40)
        promptWordLabel.textColor = .white
        promptWordLabel.text = "_"
        promptWordLabel.textAlignment = .center
        promptWordLabel.numberOfLines = 0
        view.addSubview(promptWordLabel)
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.font = UIFont.systemFont(ofSize: 36)
        scoreLabel.text = "0 Wrong Guesses"
        scoreLabel.textColor = .white
        scoreLabel.textAlignment = .center
        scoreLabel.numberOfLines = 0
        view.addSubview(scoreLabel)
        
        submitButton = UIButton(type: .system)
        submitButton.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("SUBMIT LETTER", for: .normal)
        submitButton.titleLabel?.font = UIFont(name: "PermanentMarker-Regular", size: 35)
        submitButton.backgroundColor = .black
        submitButton.tintColor = .orange
        submitButton.addTarget(self, action: #selector(promptForAnswer), for: .touchUpInside)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            gradientTitleView.widthAnchor.constraint(equalToConstant: CGFloat(gradientTitleWidth)),
            gradientTitleView.heightAnchor.constraint(equalToConstant: CGFloat(gradientTitleHeight)),
            gradientTitleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gradientTitleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            
            promptWordLabel.topAnchor.constraint(equalTo: gradientTitleView.bottomAnchor, constant: 100),
            promptWordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            promptWordLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scoreLabel.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -50),
            
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -75)
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
            if answer.trimmingCharacters(in: .whitespacesAndNewlines).count == 1 {
                self?.submit(answer)
            }
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let upperCaseAnswer = answer.uppercased()
        lettersUsed.append(upperCaseAnswer)
        
        if word.contains(upperCaseAnswer) {
            setPromptWord()
        } else {
            wrongGuesses += 1
            
            if wrongGuesses == 7 {
                showGameOver()
            } else {
                showWrongAnswerMessage(for: upperCaseAnswer)
            }
        }
    }
    
    func showWrongAnswerMessage(for answer: String) {
        let ac = UIAlertController(title: "Wrong Answer", message: "\"\(answer)\" isn't in the word.", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Submit", style: .cancel)

        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
    
    func showGameOver() {
        let ac = UIAlertController(title: "GAME OVER", message: "You lost, idiot!", preferredStyle: .alert)

        let restartAction = UIAlertAction(title: "Restart", style: .default) { [weak self] action in
            self?.wrongGuesses = 0
            self?.lettersUsed.removeAll(keepingCapacity: true)
            self?.startLevel()
        }

        ac.addAction(restartAction)
        present(ac, animated: true)
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
    
    func createGradientLabel(withText text: String) -> UIView {
        let gradientView = UIView(frame: CGRect(x: 0, y: 0, width: gradientTitleWidth, height: gradientTitleHeight))
        let gradient = CAGradientLayer()
        
        gradient.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
        
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        gradient.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradient)
        
        let label = UILabel(frame: gradientView.bounds)
        label.text = text
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
        
        return gradientView
    }
    
}

