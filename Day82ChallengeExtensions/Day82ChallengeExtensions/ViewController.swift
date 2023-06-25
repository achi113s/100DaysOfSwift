//
//  ViewController.swift
//  Day82ChallengeExtensions
//
//  Created by Giorgio Latour on 6/24/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let view = UIView()
        view.bounceOut(duration: 3)

        5.times { print("Hello") }

        var numbers = [1, 2, 3, 4, 5]
        numbers.remove(item: 3)
        print(numbers)
    }


}

