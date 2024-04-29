//
//  SplashViewModel.swift
//  Weather
//
//  Created by Berke Parıldar on 29.04.2024.
//

import Foundation
import Network

protocol SplashViewModelDelegate: AnyObject {
    func showInternetError()
    func navigateToHomePage()
}

final class SplashViewModel {
    
    weak var delegate: SplashViewModelDelegate?
    
    func checkInternetConnection() {
        let networkMonitor = NWPathMonitor()
        networkMonitor.pathUpdateHandler = { [weak self] path in
            print("Here")
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self?.delegate?.navigateToHomePage()
                }
            } else {
                DispatchQueue.main.async {
                    self?.delegate?.showInternetError()
                }
            }
            networkMonitor.cancel()
        }
        let queue = DispatchQueue.global(qos: .background)
        networkMonitor.start(queue: queue)
    }
}


