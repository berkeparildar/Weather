//
//  HomeViewController.swift
//  Weather
//
//  Created by Berke Parıldar on 29.04.2024.
//

import UIKit
import KeychainAccess

class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel!
    
    var searchController: UISearchController!
    var tableView: UITableView!
    
    var searchResults: [String] = [] {
        didSet {
            tableView.isHidden = searchResults.isEmpty
        }
    }
    var weathers: [WeatherThumbnail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupSearchController()
        setupTableView()
        setupViews()
        setupConstraints()
    }
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Locations"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setupNavigationBar() {
        self.title = "Weather"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func setupTableView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupViews() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func updateSearchResults(results: [String]) {
        searchResults = results
        tableView.reloadData()
    }
}

extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else { return }
        viewModel.performSearch(query: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchResults.removeAll()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.getWeather(index: indexPath.row) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let weather):
                self.weathers.append(weather)
                print("Name: \(weather.name), temp: \(weather.currentTemp), highestTemp: \(weather.highestTemp)")
            case .failure(_):
                print("There was an error")
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = searchResults[indexPath.row]
        return cell
    }
}


