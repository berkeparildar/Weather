//
//  WeatherViewController.swift
//  Weather
//
//  Created by Berke Parıldar on 3.05.2024.
//

import UIKit

final class WeatherViewController: UIViewController {
    
    var viewModel: WeatherViewModel!
    var hourylForecastArray = [HourlyForecast]()
    var dailyForecastArray = [DailyForecast]()
    var weeklyHigh = -100
    var weeklyLow = 100
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var baseView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.alpha = 0
        return view
    }()
    
    private lazy var blurEffect: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    private lazy var blurScreen: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        label.text = " "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowRadius = 2
        label.layer.shadowOpacity = 0.3
        return label
    }()
    
    private lazy var degreeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 60)
        label.text = " "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowRadius = 2
        label.layer.shadowOpacity = 0.3
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.text = " "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowRadius = 2
        label.layer.shadowOpacity = 0.3
        return label
    }()
    
    private lazy var minMaxLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.text = " "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowRadius = 2
        label.layer.shadowOpacity = 0.3
        return label
    }()
    
    private lazy var hourlyForecast: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 32, height: 96)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumLineSpacing = 32
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: "forecastCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var dailyForecast: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.allowsFocus = false
        tableView.separatorColor = .white
        tableView.rowHeight = 44
        tableView.register(DailyTableViewCell.self, forCellReuseIdentifier: "dailyCell")
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var hourlyForecastSection: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var hourlyForecastBlur: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    private lazy var hourlyForecastTitle: UILabel = {
        let label = UILabel()
        label.text = "Hourly Forecast"
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var hourlyForecastSeperator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var dailyForecastSection: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dailyForecastBlur: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    private lazy var dailyForecastTitle: UILabel = {
        let label = UILabel()
        label.text = "Daily Forecast"
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dailyForecastSeperator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoading(true)
        viewModel.getWeather()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        baseView.alpha = 0
        UIView.animate(withDuration: 1) {
            self.baseView.alpha = 1
        }
    }
    
    private func setupViews() {
        view.addSubview(backgroundView)
        view.addSubview(baseView)
        view.addSubview(nameLabel)
        view.addSubview(degreeLabel)
        view.addSubview(minMaxLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(hourlyForecastSection)
        view.addSubview(dailyForecastSection)
        hourlyForecastSection.addSubview(hourlyForecastBlur)
        hourlyForecastSection.addSubview(hourlyForecastTitle)
        hourlyForecastSection.addSubview(hourlyForecastSeperator)
        hourlyForecastSection.addSubview(hourlyForecast)
        dailyForecastSection.addSubview(dailyForecastBlur)
        dailyForecastSection.addSubview(dailyForecastTitle)
        dailyForecastSection.addSubview(dailyForecastSeperator)
        dailyForecastSection.addSubview(dailyForecast)
        view.addSubview(blurScreen)
        blurScreen.contentView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            blurScreen.topAnchor.constraint(equalTo: view.topAnchor),
            blurScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            
            baseView.topAnchor.constraint(equalTo: view.topAnchor),
            baseView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            baseView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            baseView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -48),
            
            degreeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            degreeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: degreeLabel.bottomAnchor, constant: 4),
            
            minMaxLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            minMaxLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            
            hourlyForecastSection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            hourlyForecastSection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            hourlyForecastSection.topAnchor.constraint(equalTo: minMaxLabel.bottomAnchor, constant: 32),
            
            hourlyForecastBlur.topAnchor.constraint(equalTo: hourlyForecastSection.topAnchor),
            hourlyForecastBlur.bottomAnchor.constraint(equalTo: hourlyForecastSection.bottomAnchor),
            hourlyForecastBlur.leadingAnchor.constraint(equalTo: hourlyForecastSection.leadingAnchor),
            hourlyForecastBlur.trailingAnchor.constraint(equalTo: hourlyForecastSection.trailingAnchor),
            
            
            hourlyForecastTitle.topAnchor.constraint(equalTo: hourlyForecastSection.topAnchor, constant: 8),
            hourlyForecastTitle.leadingAnchor.constraint(equalTo: hourlyForecastSection.leadingAnchor, constant: 16),
            
            hourlyForecastSeperator.topAnchor.constraint(equalTo: hourlyForecastTitle.bottomAnchor, constant: 4),
            hourlyForecastSeperator.leadingAnchor.constraint(equalTo: hourlyForecastSection.leadingAnchor, constant: 16),
            hourlyForecastSeperator.trailingAnchor.constraint(equalTo: hourlyForecastSection.trailingAnchor),
            hourlyForecastSeperator.heightAnchor.constraint(equalToConstant: 0.5),
            
            hourlyForecast.topAnchor.constraint(equalTo: hourlyForecastSeperator.bottomAnchor, constant: 4),
            hourlyForecast.heightAnchor.constraint(equalToConstant: 104),
            hourlyForecast.leadingAnchor.constraint(equalTo: hourlyForecastSection.leadingAnchor),
            hourlyForecast.trailingAnchor.constraint(equalTo: hourlyForecastSection.trailingAnchor),
            hourlyForecast.bottomAnchor.constraint(equalTo: hourlyForecastSection.bottomAnchor, constant: -4),
            
            dailyForecastSection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dailyForecastSection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dailyForecastSection.topAnchor.constraint(equalTo: hourlyForecastSection.bottomAnchor, constant: 32),
            
            dailyForecastBlur.topAnchor.constraint(equalTo: dailyForecastSection.topAnchor),
            dailyForecastBlur.bottomAnchor.constraint(equalTo: dailyForecastSection.bottomAnchor),
            dailyForecastBlur.leadingAnchor.constraint(equalTo: dailyForecastSection.leadingAnchor),
            dailyForecastBlur.trailingAnchor.constraint(equalTo: dailyForecastSection.trailingAnchor),
            
            
            dailyForecastTitle.topAnchor.constraint(equalTo: dailyForecastSection.topAnchor, constant: 8),
            dailyForecastTitle.leadingAnchor.constraint(equalTo: dailyForecastSection.leadingAnchor, constant: 16),
            
            dailyForecastSeperator.topAnchor.constraint(equalTo: dailyForecastTitle.bottomAnchor, constant: 4),
            dailyForecastSeperator.leadingAnchor.constraint(equalTo: dailyForecastSection.leadingAnchor, constant: 16),
            dailyForecastSeperator.trailingAnchor.constraint(equalTo: dailyForecastSection.trailingAnchor),
            dailyForecastSeperator.heightAnchor.constraint(equalToConstant: 0.5),
            
            dailyForecast.topAnchor.constraint(equalTo: dailyForecastSeperator.bottomAnchor, constant: 4),
            dailyForecast.heightAnchor.constraint(equalToConstant: 220),
            dailyForecast.leadingAnchor.constraint(equalTo: dailyForecastSection.leadingAnchor),
            dailyForecast.trailingAnchor.constraint(equalTo: dailyForecastSection.trailingAnchor),
            dailyForecast.bottomAnchor.constraint(equalTo: dailyForecastSection.bottomAnchor, constant: -4),
            
            activityIndicator.centerXAnchor.constraint(equalTo: blurScreen.contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: blurScreen.contentView.centerYAnchor)
        ])
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
}

extension WeatherViewController {
    func isLoading(_ loading: Bool) {
        if loading {
            blurScreen.alpha = 1
            activityIndicator.startAnimating()
        } else {
            UIView.animate(withDuration: 0.3) {
                self.blurScreen.alpha = 0
            }
            activityIndicator.stopAnimating()
        }
    }
    
    func didLoad() {
        isLoading(false)
    }
}

extension WeatherViewController: WeatherViewModelDelegate {
    func weatherOutput(weather: WeatherDetail) {
        dailyForecastArray = weather.dailyForecasts
        hourylForecastArray = weather.hourlyForecasts
        nameLabel.text = weather.name
        degreeLabel.text = "\(weather.degree)°"
        descriptionLabel.text = weather.description
        minMaxLabel.text = weather.minMaxInfo
        baseView.image = UIImage(named: weather.backgroundName)
        dailyForecastArray.forEach { element in
            if element.highestTemp > weeklyHigh {
                weeklyHigh = element.highestTemp
            }
            if element.lowestTemp < weeklyLow {
                weeklyLow = element.lowestTemp
            }
        }
        hourlyForecast.reloadData()
        dailyForecast.reloadData()
        didLoad()
    }
}

extension WeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hourylForecastArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "forecastCell", for: indexPath) as! HourlyCollectionViewCell
        cell.configure(forecast: hourylForecastArray[indexPath.row])
        return cell
    }
}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dailyForecastArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyCell", for: indexPath) as! DailyTableViewCell
        cell.configure(dailyForecast: dailyForecastArray[indexPath.row], weekHigh: weeklyHigh, weekLow: weeklyLow)
        return cell
    }
}
