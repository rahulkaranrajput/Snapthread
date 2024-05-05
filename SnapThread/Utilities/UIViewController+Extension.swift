//
//  UIViewController+Extension.swift
//  SnapThread
//
//  Created by Rahul K on 30/04/24.
//

import UIKit

extension UIViewController {
    func showLoader() {
        guard let window = UIApplication.shared.windows.first else { return }
        let loaderView = UIActivityIndicatorView(style: .medium)
        loaderView.startAnimating()
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(loaderView)
        loaderView.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
        loaderView.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
    }
    
    func hideLoader() {
        guard let window = UIApplication.shared.windows.first else { return }
        window.subviews.filter { $0 is UIActivityIndicatorView }.forEach { $0.removeFromSuperview() }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
