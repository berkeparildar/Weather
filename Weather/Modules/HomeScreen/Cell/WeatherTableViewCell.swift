//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Berke Parıldar on 2.05.2024.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    private lazy var baseView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
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
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var degreeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 42)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var minMaxLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        addSubview(baseView)
        baseView.addSubview(blurEffect)
        baseView.addSubview(nameLabel)
        baseView.addSubview(timeLabel)
        baseView.addSubview(degreeLabel)
        baseView.addSubview(minMaxLabel)
        baseView.addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            baseView.topAnchor.constraint(equalTo: self.topAnchor),
            baseView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            baseView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            baseView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            blurEffect.topAnchor.constraint(equalTo: baseView.topAnchor),
            blurEffect.bottomAnchor.constraint(equalTo: baseView.bottomAnchor),
            blurEffect.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            blurEffect.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 16),
            
            timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 20),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 20),
            descriptionLabel.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -16),
            
            degreeLabel.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 10),
            degreeLabel.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -20),
            
            minMaxLabel.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -20),
            minMaxLabel.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -16)
        ])
    }
    
    func configureWithWeather(model: WeatherThumbnail) {
        nameLabel.text = model.name
        degreeLabel.text = "\(model.currentTemp)°"
        var descriptionText = ""
        model.description.split(separator: " ").forEach { substring in
            let uppercased = substring.capitalized
            descriptionText += uppercased
            descriptionText += " "
        }
        descriptionLabel.text = descriptionText
        timeLabel.text = model.time
        minMaxLabel.text = "H:\(model.highestTemp)° L:\(model.lowestTemp)°"
        baseView.image = UIImage(named: model.backgroundName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
