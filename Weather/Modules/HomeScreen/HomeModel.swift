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
    var time: String
    var isDay: Bool
    var backgroundName: String
    
    static func convertToThumbnail(weatherAPI: WeatherAPI) -> WeatherThumbnail {
        let timezone = TimeZone(secondsFromGMT: weatherAPI.timezone)
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timezone
        dateFormatter.dateFormat = "HH:mm"
        let localTime = dateFormatter.string(from: currentDate)
        let isDay = weatherAPI.dt < weatherAPI.sys.sunset && weatherAPI.dt > weatherAPI.sys.sunrise
        var imageName = weatherAPI.weather.first!.main.lowercased()
        if isDay {
            imageName += "daytile"
        } else {
            imageName += "nighttile"
        }
        return WeatherThumbnail(name: weatherAPI.name, currentTemp: Int(weatherAPI.main.temp), highestTemp: Int(weatherAPI.main.tempMax), lowestTemp: Int(weatherAPI.main.tempMin), description: weatherAPI.weather.first!.description, time: localTime, isDay: isDay, backgroundName: imageName)
    }
}

