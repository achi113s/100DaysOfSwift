//
//  ViewController.swift
//  Consolidation5
//
//  Created by Giorgio Latour on 4/12/23.
//

import UIKit

class MainCollectionViewController: UICollectionViewController {
    
    var myPhotos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddPhotoView))
    }
    
    //MARK: - CollectionView Data Source Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photo", for: indexPath) as? PhotoCell else { fatalError("Unable to dequeue a PhotoCell.")}
        
        return cell
    }
    
    //MARK: - CollectionView Delegate Methods
    
    
    @objc func showAddPhotoView() {
        print("d")
    }
}

