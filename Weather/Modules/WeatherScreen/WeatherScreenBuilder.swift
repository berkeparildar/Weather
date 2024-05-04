//
//  WeatherScreenBuilder.swift
//  Weather
//
//  Created by Berke Parıldar on 3.05.2024.
//

import Foundation

final class WeatherScreenBuilder {
    static func create() -> WeatherViewController {
        let viewModel = WeatherViewModel()
        let viewController = WeatherViewController()
        viewController.viewModel = viewModel
        viewModel.delegate = viewController
        return viewController
    }
}
