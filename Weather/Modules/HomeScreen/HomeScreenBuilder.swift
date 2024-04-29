//
//  HomeScreenBuilder.swift
//  Weather
//
//  Created by Berke Parıldar on 29.04.2024.
//

import Foundation

final class HomeScreenBuilder {
    static func create() -> HomeViewController {
        let viewModel = HomeViewModel()
        let viewController = HomeViewController()
        viewController.viewModel = viewModel
        viewModel.delegate = viewController
        return viewController
    }
}
