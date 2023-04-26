//
//  ViewController.swift
//  ChallengeCountryFacts
//
//  Created by Giorgio Latour on 4/26/23.
//

import UIKit

class ViewController: UITableViewController {
    
    var countries: [Country] = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Country Facts"
        loadCountries()
    }
    
    //MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = countries[indexPath.row].name
        cell.contentConfiguration = content
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected \(countries[indexPath.row].name)!")
    }
    
    func loadCountries() {
        if let url = Bundle.main.url(forResource: "Countries", withExtension: "json") {
            if let decodedData = try? JSONDecoder().decode([Country].self, from: Data(contentsOf: url)) {
                countries = decodedData
                tableView.reloadData()
            }
        }
    }

}

