//
//  HomeViewController.swift
//  Weather
//
//  Created by Berke Parıldar on 29.04.2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}

extension HomeViewController: HomeViewModelDelegate {
    
    func showInternetError() {
        
    }
    
    func navigateToHomePage() {
        
    }
    
    
}
