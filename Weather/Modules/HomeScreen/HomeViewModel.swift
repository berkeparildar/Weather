//
//  HomeViewModel.swift
//  Weather
//
//  Created by Berke Parıldar on 29.04.2024.
//

import Foundation
import MapKit
import Moya

protocol HomeViewModelDelegate: AnyObject {
    func updateSearchResults(results: [String])
}

final class HomeViewModel: NSObject {
    
    var searchResults: [MKLocalSearchCompletion] = []
    var completer = MKLocalSearchCompleter()
    let provider = MoyaProvider<NetworkService>()
    weak var delegate: HomeViewModelDelegate?
    
    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = .address
    }
    
    func performSearch(query: String) {
        completer.queryFragment = query
    }
    
    func locationDetails(for index: Int, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let completionItem = searchResults[index]
        let request = MKLocalSearch.Request(completion: completionItem)
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let placemark = response?.mapItems.first?.placemark else {
                print("Error fetching details: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            completion(placemark.coordinate)
        }
    }
    
    func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherAPI, Error>) -> Void) {
        provider.request(.getWeatherData(latitude: latitude, longitude: longitude)) { result in
            switch result {
            case .success(let moyaResponse):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodedData = try decoder.decode(WeatherAPI.self, from: moyaResponse.data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getWeather(index: Int, completion: @escaping (Result<WeatherThumbnail, Error>) -> Void) {
        locationDetails(for: index) { [weak self] coordinates in
            guard let self = self else { return }
            guard let resultCoordinates = coordinates else { return }
            self.fetchWeather(latitude: resultCoordinates.latitude, longitude: resultCoordinates.longitude) { result in
                switch result {
                case .success(let fetchedWeather):
                    var weather = WeatherThumbnail.convertToThumbnail(weatherAPI: fetchedWeather)
                    weather.name = self.searchResults[index].title
                    completion(.success(weather))
                case .failure(_):
                    print("There was an error.")
                }
            }
        }
    }
}

extension HomeViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        let titles = searchResults.map { $0.title }
        delegate?.updateSearchResults(results: titles)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error completing search: \(error.localizedDescription)")
        delegate?.updateSearchResults(results: [])
    }
}
