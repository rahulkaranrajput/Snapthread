//
//  OTPViewController.swift
//  SnapThread
//
//  Created by Rahul K on 01/05/24.
//

import UIKit

class OTPViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: OTPViewModel!
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Verify OTP"
        label.textColor = UIColor(red: 0.20, green: 0.45, blue: 0.80, alpha: 1.00) // Blue color
        label.font = UIFont.boldSystemFont(ofSize: 24) // Make font bold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let otpTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter OTP"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let verifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Verify", for: .normal)
        button.backgroundColor = UIColor(red: 0.20, green: 0.60, blue: 0.86, alpha: 1.00) // Blue color
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(verifyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel = OTPViewModel(delegate: self)
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00) // Light gray color
        
        view.addSubview(titleLabel)
        view.addSubview(otpTextField)
        view.addSubview(verifyButton)
        
        NSLayoutConstraint.activate([
            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // OTP Text Field Constraints
            otpTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            otpTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            otpTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            otpTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Verify Button Constraints
            verifyButton.topAnchor.constraint(equalTo: otpTextField.bottomAnchor, constant: 30),
            verifyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verifyButton.widthAnchor.constraint(equalToConstant: 100),
            verifyButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Button Actions
    
    @objc private func verifyButtonTapped() {
        guard let otp = otpTextField.text, !otp.isEmpty else {
            showAlert(title: "Error", message: "Please enter OTP.")
            return
        }
        
        viewModel.verifyOTP(otp)
    }
}

// MARK: - OTPViewModelDelegate

extension OTPViewController: OTPViewModelDelegate {
    func didStartLoading() {
        showLoader()
    }
    
    func didFinishLoading() {
        hideLoader()
    }
    
    func didVerifyOTP() {
        showAlert(title: "Success", message: "OTP Verified!")
        
        // Dismiss the OTP view controller
        dismiss(animated: true) {
            // Present the tab bar controller
            let tabBarViewController = TabBarController()
            tabBarViewController.modalPresentationStyle = .fullScreen
            self.present(tabBarViewController, animated: true, completion: nil)
        }
    }
    
    func didFail(withError error: Error) {
        showAlert(title: "Error", message: error.localizedDescription)
    }
}
