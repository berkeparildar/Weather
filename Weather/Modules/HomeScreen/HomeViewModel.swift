//
//  HomeViewModel.swift
//  Weather
//
//  Created by Berke Parıldar on 29.04.2024.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func showInternetError()
    func navigateToHomePage()
}

final class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?
}
