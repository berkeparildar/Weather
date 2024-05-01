//
//  WeatherThumbnail.swift
//  Weather
//
//  Created by Berke Parıldar on 1.05.2024.
//

import Foundation

struct WeatherThumbnail {
    var name: String
    var currentTemp: Int
    var highestTemp: Int
    var lowestTemp: Int
    var description: String
    
    static func convertToThumbnail(weatherAPI: WeatherAPI) -> WeatherThumbnail {
        return WeatherThumbnail(name: weatherAPI.name, currentTemp: Int(weatherAPI.main.temp), highestTemp: Int(weatherAPI.main.tempMax), lowestTemp: Int(weatherAPI.main.tempMin), description: weatherAPI.weather.description)
    }
}

