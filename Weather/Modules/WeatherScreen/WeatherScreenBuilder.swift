//
//  WeatherScreenBuilder.swift
//  Weather
//
//  Created by Berke Parıldar on 3.05.2024.
//

import Foundation

final class WeatherScreenBuilder {
    static func create(thumbnail: WeatherThumbnail) -> WeatherViewController {
        let viewController = WeatherViewController()
        let viewModel = WeatherViewModel(delegate: viewController, weather: thumbnail)
        viewController.viewModel = viewModel
        viewModel.delegate = viewController
        return viewController
    }
}
