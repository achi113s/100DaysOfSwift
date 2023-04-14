//
//  ViewController.swift
//  Consolidation5
//
//  Created by Giorgio Latour on 4/12/23.
//

import UIKit

class MainViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var myPhotos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPhoto))
        
        title = "PhotoBook"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        loadPhotos()
    }

    
    //MARK: - UITableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPhotos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Photo", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        let photo = myPhotos[indexPath.row]
        
        content.text = photo.caption
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    //MARK: - UITableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedPhoto = myPhotos[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - UIImagePicker Delegate Methods
    
    @objc func addNewPhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appending(path: imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.9) {
            try? jpegData.write(to: imagePath)
        }
        
        let photo = Photo(photo: imageName, caption: "Unknown")
        
        dismiss(animated: true)
        
        showSavePhotoWithCaptionAlert(for: photo)
    }
    
    func showSavePhotoWithCaptionAlert(for photo: Photo) {
        let ac = UIAlertController(title: "Photo Caption", message: "Give your photo a caption!", preferredStyle: .alert)
        ac.addTextField()
        
        let saveCaptionAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak ac] _ in
            if let text = ac?.textFields?[0].text {
                photo.caption = text
                self?.myPhotos.insert(photo, at: 0)
                self?.savePhotos()
                self?.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)

        ac.addAction(cancelAction)
        ac.addAction(saveCaptionAction)
        
        present(ac, animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func savePhotos() {
        let encoder = JSONEncoder()
        
        if let savedData = try? encoder.encode(myPhotos) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "myPhotos")
        } else {
            print("Failed to save myPhotos to UserDefaults.")
        }
    }
    
    func loadPhotos() {
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: "myPhotos") as? Data {
            let decoder = JSONDecoder()
            
            do {
                myPhotos = try decoder.decode([Photo].self, from: savedData)
            } catch {
                print("Failed to load myPhotos from UserDefaults.")
            }
        }
    }
}

