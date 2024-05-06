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
    var dailyForecasts: [DailyForecast]
    var backgroundName: String
    
    static func getHour(dateString: String, timezone: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = dateFormatter.date(from: dateString)
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH"
        hourFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        let hour = hourFormatter.string(from: date!)
        return hour
    }
    
    static func getDayAbbreviation(from dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "EEE"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    static func getIcon(weather: String, hour: Int) -> String {
        var icon = "imageName"
        switch weather.lowercased() {
        case "rain":
            icon = "cloud.rain.fill"
        case "thunderstorm":
            icon = "cloud.bolt.rain.fill"
        case "drizzle":
            icon = "cloud.drizzle.fill"
        case "snow":
            icon = "cloud.snow.fill"
        case "clear":
            icon = hour < 19 && hour > 7 ? "sun.max.fill" : "moon.stars.fill"
        case "clouds":
            icon = "cloud.fill"
        default:
            icon = "sun.max.fill"
        }
        return icon
    }
    
    static func convertToDetail(forecastAPI: ForecastAPI, thumbnail: WeatherThumbnail) -> WeatherDetail {
        let upComingHours = forecastAPI.list.prefix(8)
        let timezone = forecastAPI.city.timezone
        let hourlyForecasts = upComingHours.map { apiResponse in
            let hour = getHour(dateString: apiResponse.dtTxt, timezone: timezone)
            let icon = getIcon(weather: apiResponse.weather.first!.main, hour: Int(hour)!)
            let degree = Int(apiResponse.main.temp)
            return HourlyForecast(hour: hour, icon: icon, degree: String(degree))
        }
        let dailyForecastsExceptToday = forecastAPI.list.filter { apiResponse in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: apiResponse.dtTxt)
            return !Calendar.current.isDateInToday(date!)
        }
        var descriptionText = ""
        thumbnail.description.split(separator: " ").forEach { substring in
            let uppercased = substring.capitalized
            descriptionText += uppercased
            descriptionText += " "
        }
        var dailyForecasts = [DailyForecast]()
        let bgName = thumbnail.backgroundName
        let isDay = thumbnail.backgroundName.contains("day")
        let todaysWeather = isDay ? bgName.prefix(bgName.count - 7) : bgName.prefix(bgName.count - 9)
        dailyForecasts.append(DailyForecast(day: "Today", icon: getIcon(weather: String(todaysWeather), hour: 6), lowestTemp: thumbnail.lowestTemp, highestTemp: thumbnail.highestTemp))
        for i in 0 ..< 4{
            var highest = -100.0
            var lowest = 100.0
            var dayName = ""
            var icon = "sun.max.fill"
            for j in 0 ..< 8 {
                let current = dailyForecastsExceptToday[j + (i * 8)]
                dayName = getDayAbbreviation(from: current.dtTxt)!
                if current.main.tempMax > highest {
                    highest = current.main.tempMax
                }
                if current.main.tempMin < lowest {
                    lowest = current.main.tempMin
                }
                let main = current.weather.first!.main
                if main == "Rain" || main == "Thunderstorm" || main == "Snow" || main == "Cloud" || main == "Drizzle" {
                    icon = getIcon(weather: main, hour: 6)
                }
            }
            dailyForecasts.append(DailyForecast(day: dayName, icon: icon, lowestTemp: Int(lowest), highestTemp: Int(highest)))
        }
        return WeatherDetail(name: thumbnail.name, degree: "\(thumbnail.currentTemp)", description: descriptionText, minMaxInfo: "H:\(thumbnail.highestTemp)° L:\(thumbnail.lowestTemp)°", hourlyForecasts: hourlyForecasts, dailyForecasts: dailyForecasts, backgroundName: String(bgName.prefix(bgName.count - 4)))
    }
}

struct HourlyForecast {
    var hour: String
    var icon: String
    var degree: String
}

struct DailyForecast {
    var day: String
    var icon: String
    var lowestTemp: Int
    var highestTemp: Int
}

