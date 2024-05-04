//
//  WeatherViewController.swift
//  Weather
//
//  Created by Berke Parıldar on 3.05.2024.
//

import UIKit

final class WeatherViewController: UIViewController {
    
    var viewModel: WeatherViewModel!
    
    var forecasts: [HourlyForecast] = [
        HourlyForecast(hour: "18", icon: UIImage(systemName: "cloud.drizzle.fill")!, degree: "22"),
        HourlyForecast(hour: "18", icon: UIImage(systemName: "cloud.drizzle.fill")!, degree: "22"),
        HourlyForecast(hour: "18", icon: UIImage(systemName: "cloud.drizzle.fill")!, degree: "22"),
        HourlyForecast(hour: "18", icon: UIImage(systemName: "cloud.drizzle.fill")!, degree: "22"),
        HourlyForecast(hour: "18", icon: UIImage(systemName: "cloud.drizzle.fill")!, degree: "22"),
        HourlyForecast(hour: "18", icon: UIImage(systemName: "cloud.drizzle.fill")!, degree: "22"),
        HourlyForecast(hour: "18", icon: UIImage(systemName: "cloud.drizzle.fill")!, degree: "22"),
        HourlyForecast(hour: "18", icon: UIImage(systemName: "cloud.drizzle.fill")!, degree: "22"),
    ]
    
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
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var degreeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 60)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var minMaxLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var hourlyForecast: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 16, height: 120)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumLineSpacing = 32
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: "forecastCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var forecastSection: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var forecastBlur: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    private lazy var forecastTitle: UILabel = {
        let label = UILabel()
        label.text = "Hourly Forecast"
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        baseView.alpha = 0
        
        // Animate the alpha property of the baseView to 1 with a duration of 0.5 seconds
        UIView.animate(withDuration: 1) {
            self.baseView.alpha = 1
        }
    }
    
    private func setupViews() {
        view.addSubview(backgroundView)
        view.addSubview(baseView)
        //baseView.addSubview(blurEffect)
        view.addSubview(nameLabel)
        view.addSubview(degreeLabel)
        view.addSubview(minMaxLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(forecastSection)
        forecastSection.addSubview(forecastBlur)
        forecastSection.addSubview(forecastTitle)
        forecastSection.addSubview(seperatorView)
        forecastSection.addSubview(hourlyForecast)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            baseView.topAnchor.constraint(equalTo: view.topAnchor),
            baseView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            baseView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            baseView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            /*
             blurEffect.topAnchor.constraint(equalTo: baseView.topAnchor),
             blurEffect.bottomAnchor.constraint(equalTo: baseView.bottomAnchor),
             blurEffect.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
             blurEffect.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),*/
            
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -48),
            
            degreeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            degreeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: degreeLabel.bottomAnchor, constant: 4),
            
            minMaxLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            minMaxLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            
            forecastSection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            forecastSection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            forecastSection.topAnchor.constraint(equalTo: minMaxLabel.bottomAnchor, constant: 42),
            
            forecastBlur.topAnchor.constraint(equalTo: forecastSection.topAnchor),
            forecastBlur.bottomAnchor.constraint(equalTo: forecastSection.bottomAnchor),
            forecastBlur.leadingAnchor.constraint(equalTo: forecastSection.leadingAnchor),
            forecastBlur.trailingAnchor.constraint(equalTo: forecastSection.trailingAnchor),
            
            
            forecastTitle.topAnchor.constraint(equalTo: forecastSection.topAnchor, constant: 16),
            forecastTitle.leadingAnchor.constraint(equalTo: forecastSection.leadingAnchor, constant: 16),
            
            seperatorView.topAnchor.constraint(equalTo: forecastTitle.bottomAnchor, constant: 4),
            seperatorView.leadingAnchor.constraint(equalTo: forecastSection.leadingAnchor, constant: 16),
            seperatorView.trailingAnchor.constraint(equalTo: forecastSection.trailingAnchor),
            seperatorView.heightAnchor.constraint(equalToConstant: 1),
            
            hourlyForecast.topAnchor.constraint(equalTo: seperatorView.bottomAnchor, constant: 4),
            hourlyForecast.heightAnchor.constraint(equalToConstant: 120),
            hourlyForecast.leadingAnchor.constraint(equalTo: forecastSection.leadingAnchor),
            hourlyForecast.trailingAnchor.constraint(equalTo: forecastSection.trailingAnchor),
            hourlyForecast.bottomAnchor.constraint(equalTo: forecastSection.bottomAnchor, constant: -4)
        ])
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func configureWithWeather() {
        nameLabel.text = "Turgutlu"
        degreeLabel.text = "24°"
        descriptionLabel.text = "Partly Cloudy"
        minMaxLabel.text = "H:27° L:12°"
        baseView.image = UIImage(named: "cloudsnight")
    }
}

extension WeatherViewController: WeatherViewModelDelegate {
    
}

extension WeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "forecastCell", for: indexPath) as! HourlyCollectionViewCell
        cell.configure(forecast: forecasts[indexPath.row])
        return cell
    }
}
