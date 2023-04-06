//
//  ViewController.swift
//  Hangman
//
//  Created by Giorgio Latour on 4/4/23.
//

import UIKit

class ViewController: UIViewController {
    
    private var currentWordLabel: UILabel!
    private var gradientTitle: UIView!
    private let gradientTitleWidth = 300
    private let gradientTitleHeight = 80
    
    private var words: [String] = [String]()
    private var levelWord: [Character] = [Character]()
    
    override func loadView() {
        super.loadView()
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.cgColor, UIColor.white.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
        
        createGradientTitle()
        
        currentWordLabel = UILabel()
        currentWordLabel.translatesAutoresizingMaskIntoConstraints = false
        currentWordLabel.font = UIFont.systemFont(ofSize: 36)
        currentWordLabel.text = "_"
        currentWordLabel.textAlignment = .center
        currentWordLabel.numberOfLines = 0
        view.addSubview(currentWordLabel)
        
        NSLayoutConstraint.activate([
            gradientTitle.widthAnchor.constraint(equalToConstant: CGFloat(gradientTitleWidth)),
            gradientTitle.heightAnchor.constraint(equalToConstant: CGFloat(gradientTitleHeight)),
            gradientTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gradientTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            
            currentWordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentWordLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            currentWordLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
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
                words.shuffle()
            }
        } else {
            words = ["Empty"]
        }
        startLevel()
    }
    
    func startLevel() {
        DispatchQueue.main.async { [weak self] in
            var blankString = ""
            for c in (self?.words.first)! {
                blankString += "_"
                self?.levelWord.append(c)
            }
            self?.currentWordLabel.text = blankString
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

