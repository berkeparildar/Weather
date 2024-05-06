//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Berke Parıldar on 3.05.2024.
//

import Foundation
import Moya

protocol WeatherViewModelDelegate: AnyObject {
    func weatherOutput(weather: WeatherDetail)
}

final class WeatherViewModel {
    weak var delegate: WeatherViewModelDelegate?
    let provider = MoyaProvider<NetworkService>()
    let weather: WeatherThumbnail
    
    init(delegate: WeatherViewModelDelegate? = nil, weather: WeatherThumbnail) {
        self.delegate = delegate
        self.weather = weather
    }
    
    func fetchForecast(latitude: Double, longitude: Double, completion: @escaping (Result<ForecastAPI, Error>) -> Void) {
        provider.request(.getForecastData(latitude: latitude, longitude: longitude)) { result in
            switch result {
            case .success(let moyaResponse):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodedData = try decoder.decode(ForecastAPI.self, from: moyaResponse.data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getWeather() {
        self.fetchForecast(latitude: weather.latitude, longitude: weather.longitude) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let forecast):
                let weatherDetail = WeatherDetail.convertToDetail(forecastAPI: forecast, thumbnail: weather)
                delegate?.weatherOutput(weather: weatherDetail)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
}
