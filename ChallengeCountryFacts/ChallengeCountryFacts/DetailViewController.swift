//
//  DetailViewController.swift
//  ChallengeCountryFacts
//
//  Created by Giorgio Latour on 4/26/23.
//

import UIKit

class DetailViewController: UITableViewController {
    
    var country: Country!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = country.name
    }
    
    //MARK: - TableView Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // number of attributes for Country plus a row for the flag
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailViewCell", for: indexPath)
        cell.selectionStyle = .none
        let row = indexPath.row
        var content = cell.defaultContentConfiguration()
        
        switch row {
        case 0:
            content.image = UIImage(named: country.name)
        case 1:
            content.text = country.name
        case 2:
            content.text = "Capital: \(country.capitalCity)"
        case 3:
            content.text = "Size: \(country.size)"
        case 4:
            content.text = "Population: \(country.population.formatted(.number))"
        case 5:
            content.text = "Currency: \(country.currency)"
        case 6:
            content.text = country.description
        default:
            content.text = ""
        }
        
        cell.contentConfiguration = content
        return cell
    }
}
