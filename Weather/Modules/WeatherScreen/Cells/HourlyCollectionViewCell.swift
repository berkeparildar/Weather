//
//  HourlyCollectionViewCell.swift
//  Weather
//
//  Created by Berke Parıldar on 3.05.2024.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    private let hourLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let degreeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        addSubview(hourLabel)
        addSubview(weatherImage)
        addSubview(degreeLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            hourLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            hourLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            hourLabel.widthAnchor.constraint(equalToConstant: 24),
            hourLabel.heightAnchor.constraint(equalToConstant: 24),
            weatherImage.topAnchor.constraint(equalTo: hourLabel.bottomAnchor, constant: 4),
            weatherImage.widthAnchor.constraint(equalToConstant: 24),
            weatherImage.heightAnchor.constraint(equalToConstant: 24),
            weatherImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            degreeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            degreeLabel.topAnchor.constraint(equalTo: weatherImage.bottomAnchor, constant: 4),
            degreeLabel.widthAnchor.constraint(equalToConstant: 24),
            degreeLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(forecast: HourlyForecast) {
        hourLabel.text = forecast.hour
        weatherImage.image = forecast.icon
        degreeLabel.text = forecast.degree
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
