//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Berke Parıldar on 3.05.2024.
//

import Foundation

protocol WeatherViewModelDelegate: AnyObject {
   
}

final class WeatherViewModel {
    weak var delegate: WeatherViewModelDelegate?
}
