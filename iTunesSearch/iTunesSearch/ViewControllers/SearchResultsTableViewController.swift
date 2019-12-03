//
//  SearchResultsTableViewController.swift
//  iTunesSearch
//
//  Created by Patrick Millet on 12/3/19.
//  Copyright © 2019 Patrick Millet. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    //MARK: - Properties
    
    private let searchResultsController = SearchResultController()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultsController.searchResults.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        let result = searchResultsController.searchResults[indexPath.row]
        cell.textLabel?.text = result.creator
        cell.detailTextLabel?.text = result.title
        
        return cell
    }
}


    //MARK: Protocols
extension SearchResultsTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var resultType: ResultType!
        guard let searchTerm = searchBar.text else { return }
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            resultType = .software
        case 1:
            resultType = .movie
        case 2:
            resultType = .musicTrack
        default:
            resultType = .software
        }
        
        searchResultsController.searchResultsWith(searchTerm: searchTerm, resultType: resultType) {_ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
