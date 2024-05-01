//
//  WeatherAPI.swift
//  Weather
//
//  Created by Berke Parıldar on 1.05.2024.
//

import Foundation

struct WeatherAPI: Decodable {
    var weather: [WeatherDescription]
    var main: WeatherData
    var name: String
    var dt: Int
    var timezone: Int
}

struct WeatherDescription: Decodable {
    var main: String
    var description: String
}

struct WeatherData: Decodable {
    var temp: Double
    var feelsLike: Double
    var tempMin: Double
    var tempMax: Double
    var humidity: Double
}
