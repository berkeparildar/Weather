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
    var searchTableView: UITableView!
    var weatherTableView: UITableView!
    
    var searchResults: [String] = [] {
        didSet {
            searchTableView.isHidden = searchResults.isEmpty
        }
    }
    var weathers: [WeatherThumbnail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSearchController()
        setupWeatherTableView()
        setupSearchTableView()
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
    
    
    func setupSearchTableView() {
        searchTableView = UITableView()
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.isHidden = false
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupWeatherTableView() {
        weatherTableView = UITableView()
        weatherTableView.separatorStyle = .none
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        weatherTableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "weatherCell")
        weatherTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupViews() {
        view.addSubview(weatherTableView)
        view.addSubview(searchTableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            weatherTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weatherTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            weatherTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            weatherTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func updateSearchResults(results: [String]) {
        searchResults = results
        searchTableView.reloadData()
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
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchTableView {
            return searchResults.count
        }
        return weathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchTableView {
            let cell = UITableViewCell()
            cell.textLabel?.text = searchResults[indexPath.row]
            return cell
        }
        let cell = weatherTableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherTableViewCell
        cell.configureWithWeather(model: weathers[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == searchTableView {
            return 44
        }
        return 136
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.getWeather(index: indexPath.row) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let weather):
                self.weathers.append(weather)
                print("Name: \(weather.name), temp: \(weather.currentTemp), highestTemp: \(weather.highestTemp)")
                searchController.isActive = false
                searchResults.removeAll()
                weatherTableView.reloadData()
            case .failure(_):
                print("There was an error")
            }
        }
    }
}


