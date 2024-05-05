//
//  WeatherModel.swift
//  Weather
//
//  Created by Berke Parıldar on 3.05.2024.
//

import UIKit

struct WeatherDetail {
    var name: String
    var degree: String
    var description: String
    var minMaxInfo: String
    var hourlyForecasts: [HourlyForecast]
}

struct HourlyForecast {
    var hour: String
    var icon: UIImage
    var degree: String
}

struct DailyForecast {
    var day: String
    var icon: UIImage
    var lowestTemp: Int
    var highestTemp: Int
    var currentTemp: Int
}
