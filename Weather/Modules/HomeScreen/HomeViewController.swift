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
    
    lazy var searchView: UIView = {
        let view = UIView(frame: view.safeAreaLayoutGuide.layoutFrame)
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoading()
        setupNavigationBar()
        setupSearchController()
        setupWeatherTableView()
        setupSearchTableView()
        setupViews()
        setupConstraints()
        viewModel.fetchSavedLoations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()  // Forces the layout of the subviews immediately
        }
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
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func setupSearchTableView() {
        searchTableView = UITableView()
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.isHidden = true
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupWeatherTableView() {
        weatherTableView = UITableView()
        weatherTableView.separatorStyle = .none
        weatherTableView.dataSource = self
        weatherTableView.rowHeight = 136
        weatherTableView.delegate = self
        weatherTableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "weatherCell")
        weatherTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupViews() {
        view.addSubview(weatherTableView)
        view.addSubview(searchView)
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
    
    func updateWeatherTable(weathers: [WeatherThumbnail]) {
        self.weathers = weathers
        self.weatherTableView.reloadData()
        didLoad()
    }
}

extension HomeViewController: LoadingShowable {
    func isLoading() {
        LoadingView.shared.startLoading()
    }
    
    func didLoad() {
        LoadingView.shared.hideLoading()
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchView.backgroundColor = .gray.withAlphaComponent(0)
        searchView.isHidden = false
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.view.layoutIfNeeded()
            self.searchView.backgroundColor = .black.withAlphaComponent(0.5)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchView.backgroundColor = .black.withAlphaComponent(0.5)
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.view.layoutIfNeeded()
            self.searchView.backgroundColor = .black.withAlphaComponent(0)
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.searchView.isHidden = true
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == weatherTableView {
            let weatherView = WeatherScreenBuilder.create(thumbnail: weathers[indexPath.row])
            navigationController?.pushViewController(weatherView, animated: true)
        }
        else {
            viewModel.getWeather(index: indexPath.row) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let weather):
                    self.weathers.append(weather)
                    searchController.isActive = false
                    searchResults.removeAll()
                    weatherTableView.reloadData()
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if tableView == weatherTableView {
                viewModel.removeWeather(name: weathers[indexPath.row].name)
                weathers.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == weatherTableView {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
                guard let self = self else { return }
                self.viewModel.removeWeather(name: weathers[indexPath.row].name)
                self.weathers.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                completionHandler(true)
            }
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 17.0, weight: .bold, scale: .large)
            deleteAction.image = UIImage(systemName: "trash", withConfiguration: largeConfig)?.withTintColor(.white, renderingMode: .alwaysTemplate).addBackgroundCircle(.systemRed)
            deleteAction.backgroundColor = .systemBackground
            deleteAction.title = "Delete"
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
        }
        return nil
    }
    
}


