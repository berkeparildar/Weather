//
//  SplashViewController.swift
//  Weather
//
//  Created by Berke Parıldar on 29.04.2024.
//

import UIKit

class SplashViewController: UIViewController, ShowAlert {
    
    var viewModel: SplashViewModel!
    
    var background: UIView = {
        var backgroundView = UIView()
        backgroundView.backgroundColor = .black
        return backgroundView
    }()
    
    var splashLogo: UIImageView = {
        var logo = UIImageView()
        logo.image = UIImage(named: "weather")
        return logo
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.checkInternetConnection()
    }
    
    func setupViews() {
        self.background.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(background)
        splashLogo.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(splashLogo)
        NSLayoutConstraint.activate([
            self.background.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.background.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.background.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.background.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.splashLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.splashLogo.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.splashLogo.widthAnchor.constraint(equalToConstant: 120),
            self.splashLogo.heightAnchor.constraint(equalToConstant: 120),
            
        ])
        
    }
}

extension SplashViewController: SplashViewModelDelegate {
    
    func navigateToHomePage() {
        guard let window = self.view.window else { return }
        let homeVC = HomeScreenBuilder.create()
        let navigationController = UINavigationController(rootViewController: homeVC)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            window.rootViewController = navigationController
        }
    }
    
    func showInternetError() {
        showAlert(title: "İnternet bağlantısı yok", message: "Bağlantıyı sağlayıp tekrar deneyin")
    }
}
