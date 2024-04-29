//
//  SplashScreenBuilder.swift
//  Weather
//
//  Created by Berke Parıldar on 29.04.2024.
//

import Foundation

final class SplashScreenBuilder {
    static func create() -> SplashViewController {
        let viewModel = SplashViewModel()
        let viewController = SplashViewController()
        viewController.viewModel = viewModel
        viewModel.delegate = viewController
        return viewController
    }
}
