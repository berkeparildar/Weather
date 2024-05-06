//
//  LoadingView.swift
//  Weather
//
//  Created by Berke Parıldar on 6.05.2024.
//

import UIKit

protocol LoadingShowable where Self: UIViewController {
    func showLoading()
    func hideLoading()
}

extension LoadingShowable {
    func showLoading() {
        LoadingView.shared.startLoading()
    }
    
    func hideLoading() {
        LoadingView.shared.hideLoading()
    }
}

final class LoadingView {
    
    static let shared = LoadingView()
    
    private var backgroundView: UIView!
    private var logoImage: UIImageView!
    
    
    private init() {
        setupViews()
    }
    
    private func setupViews() {
        backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = .systemBackground
        
        logoImage = UIImageView()
        logoImage.image = UIImage(named: "weather")
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addSubview(logoImage)
        
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: 120),
            logoImage.heightAnchor.constraint(equalToConstant: 120)
        ])
        
    }
    
    private func setupPulseAnimation() {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 0.8
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.2
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.infinity
        logoImage.layer.add(pulseAnimation, forKey: "pulseAnimation")
    }
    
    func startLoading() {
        setupPulseAnimation()
        UIApplication.shared.windows.first(where: \.isKeyWindow)?.addSubview(backgroundView)
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.logoImage.layer.removeAllAnimations()
            self.backgroundView.removeFromSuperview()
        }
    }
}

