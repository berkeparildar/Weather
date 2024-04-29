//
//  ShowAlert.swift
//  Weather
//
//  Created by Berke Parıldar on 29.04.2024.
//

import UIKit

/*
 This function displays a native alert dialog with a single option of "OK". This is used only when there is no
 internet connection available during the start of application.
 */

protocol ShowAlert {
    func showAlert(title: String, message: String)
}

extension ShowAlert where Self: UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Tamam", style: .default)
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
