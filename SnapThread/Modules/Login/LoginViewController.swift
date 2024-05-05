//
//  LoginVC.swift
//  SnapThread
//
//  Created by Rahul K on 30/04/24.
//

import UIKit

class LoginViewController: UIViewController, KeyboardToolbarDelegate {

    // MARK: - Properties

    private var viewModel: LoginViewModel!

    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome \nSnap Thread"
        label.textColor = UIColor(red: 0.20, green: 0.45, blue: 0.80, alpha: 1.00)
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight(rawValue: 20))
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let countryPickerTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Select Country"
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Phone Number"
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = .roundedRect
        textField.keyboardType = .phonePad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login/Singup", for: .normal)
        button.backgroundColor = UIColor(red: 0.20, green: 0.60, blue: 0.86, alpha: 1.00) // Updated color
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel = LoginViewModel(delegate: self)
        
        // Add "Done" button to text fields
        KeyboardToolbarHelper.addDoneButton(to: countryPickerTextField, delegate: self)
        KeyboardToolbarHelper.addDoneButton(to: phoneNumberTextField, delegate: self)
    }
    
    func doneButtonTapped() {
        view.endEditing(true)
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        view.addSubview(titleLabel)
        view.addSubview(countryPickerTextField)
        view.addSubview(phoneNumberTextField)
        view.addSubview(loginButton)

        applyConstraints()
        
        // Add tap gesture recognizer to countryPickerTextField to open country picker
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openCountryPicker))
        countryPickerTextField.addGestureRecognizer(tapGesture)
        
        // Set input view of countryPickerTextField to country picker
        let countryPicker = CountryPicker()
        countryPicker.countryTextField = countryPickerTextField
        countryPickerTextField.inputView = countryPicker
    }

    // MARK: - Button Actions

    @objc private func loginButtonTapped() {
        guard let phoneNumber = phoneNumberTextField.text else {
            showAlert(title: "Error", message: "Please enter a phone number.")
            return
        }

        // Check if the phone number is in the correct format
        guard isValidPhoneNumber(phoneNumber) else {
            showAlert(title: "Error", message: "Please enter a valid phone number.")
            return
        }

        let countryCode = countryPickerTextField.text ?? "" // Get the selected country code
        let fullPhoneNumber = "\(countryCode) \(phoneNumber)"
        viewModel.login(withPhoneNumber: fullPhoneNumber)
    }
    
    @objc private func openCountryPicker() {
        countryPickerTextField.becomeFirstResponder() // Show the country picker when tapping on countryPickerTextField
    }

    @objc private func closeCountryPicker() {
        countryPickerTextField.resignFirstResponder() // Dismiss the country picker when tapping the done button
    }
}

extension LoginViewController {
    // MARK: - Phone Number Validation
    private func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^\\+?[0-9]{7,}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phoneNumber)
    }

}
// MARK: - LoginViewModelDelegate

extension LoginViewController: LoginViewModelDelegate {
    func didStartLoading() {
        showLoader()
    }

    func didFinishLoading() {
        hideLoader()
    }

    func didFinishLogin() {
        navigateToNextScreen()
    }

    func didFail(withError error: Error) {
        showAlert(title: "Error", message: error.localizedDescription)
    }
}

// MARK: - Navigation

extension LoginViewController {
    private func navigateToNextScreen() {
        // Navigate to the next screen upon successful login
        let otpViewController = OTPViewController()
        navigationController?.pushViewController(otpViewController, animated: true)
    }
}

extension LoginViewController {
    private func applyConstraints() {
        // Title Label Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Country Picker Text Field Constraints
        NSLayoutConstraint.activate([
            countryPickerTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            countryPickerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            countryPickerTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35),
            countryPickerTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Phone Number Text Field Constraints
        NSLayoutConstraint.activate([
            phoneNumberTextField.topAnchor.constraint(equalTo: countryPickerTextField.topAnchor),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: countryPickerTextField.trailingAnchor, constant: 20),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Login Button Constraints
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 30),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 150),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
