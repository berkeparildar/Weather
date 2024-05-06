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
    var sys: SystemData
}

struct WeatherDescription: Decodable {
    var id: Int
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

struct SystemData: Decodable {
    var sunset: Int
    var sunrise: Int
}

struct ForecastAPI: Decodable {
    var list: [ForecastWeather]
    var city: LocalInfo
}

struct ForecastWeather: Decodable {
    var weather: [WeatherDescription]
    var main: WeatherData
    var dtTxt: String
}

struct LocalInfo: Decodable {
    var timezone: Int
}
