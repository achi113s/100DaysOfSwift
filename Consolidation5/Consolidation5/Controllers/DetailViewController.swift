//
//  DetailViewController.swift
//  Consolidation5
//
//  Created by Giorgio Latour on 4/12/23.
//

import UIKit

class DetailViewController: UIViewController {

    var selectedPhoto: Photo?
    
    var photoView: UIImageView!
    var image: UIImage!
    var captionLabel: UILabel!
    
    override func loadView() {
        super.loadView()
        
        photoView = UIImageView()
        photoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photoView)
        
        captionLabel = UILabel()
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(captionLabel)
        
        NSLayoutConstraint.activate([
            photoView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            photoView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            photoView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            photoView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            
            captionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            captionLabel.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 10)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let photo = selectedPhoto else { return }
        
        let pathToImage = getDocumentsDirectory().appending(path: photo.photo)
        
        photoView.image = UIImage(contentsOfFile: pathToImage.path())
        captionLabel.text = photo.caption
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
