//
//  DetailViewController.swift
//  Project3b
//
//  Created by Giorgio Latour on 3/26/23.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let imageToShow = selectedImage {
            imageView.image = UIImage(named: imageToShow)
        }
    }
}
