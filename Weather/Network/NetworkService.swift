//
//  NetworkService.swift
//  Weather
//
//  Created by Berke Parıldar on 1.05.2024.
//

import Moya
import Foundation
import KeychainAccess

enum NetworkService {
    case getWeatherData(latitude: Double, longitude: Double)
}

enum NetworkError: Error {
    case unknown
}

extension NetworkService: TargetType {
    
    func loadAPIKey() -> String? {
        let keychain = Keychain(service: "com.bprldr.Weather")
        do {
            return try keychain.getString("OpenWeatherMapAPIKey")
        } catch let error {
            print("Error retrieving API key from Keychain: \(error)")
            return nil
        }
    }
    
    var baseURL: URL {
        URL(string: "https://api.openweathermap.org")!
    }
    
    var path: String {
        "/data/2.5/weather"
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Task {
        switch self {
        case .getWeatherData(let latitude, let longitude):
            let parameters: [String: Any] = [
                "lat": latitude,
                "lon": longitude,
                "appid": loadAPIKey() ?? "",
                "units": "metric"
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
