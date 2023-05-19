//
//  ViewController.swift
//  NotesClone
//
//  Created by Giorgio Latour on 5/17/23.
//

import UIKit

class HomeViewController: UIViewController {

    var tableView: UITableView!
    var notes: [Note]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemYellow
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(createNewNote))
        
        loadData()
        
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func createNewNote() {
        let ac = UIAlertController(title: "New Note", message: "Give your note a title.", preferredStyle: .alert)
        ac.addTextField()
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] action in
            let noteVC = NoteViewController()
            let newNote = Note(title: ac.textFields?.first?.text ?? "", content: "")
            noteVC.note = newNote
            
            self?.notes.append(newNote)
            self?.tableView.reloadData()
            
            self?.navigationController?.pushViewController(noteVC, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(cancelAction)
        ac.addAction(okAction)
        
        present(ac, animated: true)
    }
    
    func saveData() {
        do {
            let data = try JSONEncoder().encode(notes)
            try data.write(to: FileManager.notesSavePath, options: [.atomic])
        } catch {
            print("Unable to save data.")
        }
    }
    
    func loadData() {
        do {
            let data = try Data(contentsOf: FileManager.notesSavePath)
            notes = try JSONDecoder().decode([Note].self, from: data)
        } catch {
            notes = [Note]()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let note = notes[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = note.title
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteVC = NoteViewController()
        
        noteVC.note = notes[indexPath.row]
        
        UIView.animate(withDuration: 1) {
            tableView.cellForRow(at: indexPath)?.isSelected = false
        }
        
        navigationController?.pushViewController(noteVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, sourceView, completionHandler in
            let row = indexPath.row
            
            DispatchQueue.main.async {
                self?.notes.remove(at: row)
                self?.tableView.deleteRows(at: [indexPath], with: .left)
                self?.tableView.reloadData()
                self?.saveData()
            }
            completionHandler(true)
        }
        
        let editTitle = UIContextualAction(style: .normal, title: "Edit Title") { [weak self] action, sourceView, completionHandler in
            let row = indexPath.row
            
            let ac = UIAlertController(title: "Edit Note Title", message: "", preferredStyle: .alert)
            ac.addTextField()
            ac.textFields?.first?.text = self?.notes[row].title
            
            let editAction = UIAlertAction(title: "Done", style: .default) { action in
                self?.notes[row].title = ac.textFields?.first?.text ?? ""
                ac.dismiss(animated: true)
                self?.tableView.reloadData()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            ac.addAction(cancelAction)
            ac.addAction(editAction)
            
            self?.present(ac, animated: true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editTitle])
    }
}
