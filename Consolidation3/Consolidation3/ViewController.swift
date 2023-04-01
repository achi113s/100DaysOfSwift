//
//  ViewController.swift
//  Consolidation3
//
//  Created by Giorgio Latour on 3/31/23.
//

import UIKit

class ViewController: UITableViewController {

    var shoppingItems = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddItem))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(showClearItemsConfirm))
    }
    
    @objc func showAddItem() {
        let ac = UIAlertController(title: "Add Shopping Item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let submitText = ac?.textFields?[0].text else { return }
            self?.submit(submitText)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func showClearItemsConfirm() {
        let ac = UIAlertController(title: "Are you sure you want to clear the shopping list?", message: nil, preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Clear", style: .default) { [weak self] action in
            self?.clearItems()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(cancelAction)
        ac.addAction(submitAction)
        present(ac, animated: true)
    }

    func submit(_ text: String) {
        shoppingItems.insert(text, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func clearItems() {
        shoppingItems = [String]()
        tableView.reloadData()
    }
    
    //MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = shoppingItems[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
}

