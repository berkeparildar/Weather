//
//  DailyTableViewCell.swift
//  Weather
//
//  Created by Berke Parıldar on 5.05.2024.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    
    var highestDegree: Int!
    var lowestDegree: Int!
    var defaultLeadingConstraint: NSLayoutConstraint!
    var defaultTrailingConstraint: NSLayoutConstraint!
    
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var minTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var maxTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var scalaView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.layer.cornerRadius = 2
        return view
    }()
    
    private lazy var gradientContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        return view
    }()
    
    private let gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.cyan.cgColor,
            UIColor.green.cgColor,
            UIColor.yellow.cgColor,
            UIColor.orange.cgColor
        ]
        gradientLayer.locations = [0.0, 0.25, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.layer.cornerRadius = 4
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(minTempLabel)
        addSubview(maxTempLabel)
        addSubview(weatherImage)
        addSubview(dayLabel)
        addSubview(scalaView)
        gradientContainer.addSubview(gradientView)
        addSubview(gradientContainer)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
                gradientLayer.frame = gradientView.bounds
            } else {
                let gradientLayer = CAGradientLayer()
                gradientLayer.colors = [
                    UIColor.cyan.cgColor,
                    UIColor.green.cgColor,
                    UIColor.yellow.cgColor,
                    UIColor.orange.cgColor
                ]
                gradientLayer.locations = [0.0, 0.25, 0.5, 1.0]
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 1)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 1)
                gradientLayer.frame = gradientView.bounds
                gradientView.layer.insertSublayer(gradientLayer, at: 0)
            }
    }
    
    private func setupConstraints() {
        
        defaultLeadingConstraint = gradientContainer.leadingAnchor.constraint(equalTo: scalaView.leadingAnchor)
        defaultTrailingConstraint = gradientContainer.trailingAnchor.constraint(equalTo: scalaView.trailingAnchor)
        
        NSLayoutConstraint.activate([
            dayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            weatherImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            weatherImage.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -30),
            
            minTempLabel.trailingAnchor.constraint(equalTo: scalaView.leadingAnchor, constant: -16),
            minTempLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            scalaView.trailingAnchor.constraint(equalTo: maxTempLabel.leadingAnchor, constant: -16),
            scalaView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            scalaView.widthAnchor.constraint(equalToConstant: 60),
            scalaView.heightAnchor.constraint(equalToConstant: 4),
            
            defaultLeadingConstraint,
            defaultTrailingConstraint,
            gradientContainer.topAnchor.constraint(equalTo: scalaView.topAnchor),
            gradientContainer.bottomAnchor.constraint(equalTo: scalaView.bottomAnchor),
            
            gradientView.leadingAnchor.constraint(equalTo: gradientContainer.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: gradientContainer.trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: gradientContainer.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: gradientContainer.bottomAnchor),
            
            maxTempLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            maxTempLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
    
        ])
    }
    
    func configure(dailyForecast: DailyForecast, weekHigh: Int, weekLow: Int) {
        highestDegree = weekHigh
        lowestDegree = weekLow
        var difference = highestDegree - lowestDegree
        var multiplier = 60 / difference
        var lowestDifference = dailyForecast.lowestTemp - lowestDegree
        var highestDifference = highestDegree - dailyForecast.highestTemp
        defaultLeadingConstraint.isActive = false
        defaultTrailingConstraint.isActive = false
        NSLayoutConstraint.activate([
            gradientContainer.leadingAnchor.constraint(equalTo: scalaView.leadingAnchor, constant: CGFloat(lowestDifference * multiplier)),
            gradientContainer.trailingAnchor.constraint(equalTo: scalaView.trailingAnchor, constant: CGFloat(-highestDifference * multiplier))
        ])
        dayLabel.text = dailyForecast.day
        let iconImage = UIImage(systemName: dailyForecast.icon)
        let config = UIImage.SymbolConfiguration.preferringMulticolor()
        var multicolorImage = iconImage?.applyingSymbolConfiguration(config)
        weatherImage.image = multicolorImage
        minTempLabel.text = "\(dailyForecast.lowestTemp)°"
        maxTempLabel.text = "\(dailyForecast.highestTemp)°"
    }
}
