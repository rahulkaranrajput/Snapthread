//
//  LoginViewModel.swift
//  SnapThread
//
//  Created by Rahul K on 30/04/24.
//

import Foundation

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func didStartLoading()
    func didFinishLoading()
    func didFinishLogin()
    func didFail(withError error: Error)
}

class LoginViewModel {
    
    weak var delegate: LoginViewModelDelegate?
    
    private let authenticationManager: AuthenticationManager
    
    init() {
        authenticationManager = AuthenticationManager.shared
    }
    
    // Updated initializer without delegate argument
    convenience init(delegate: LoginViewModelDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    func login(withPhoneNumber phoneNumber: String) {
        delegate?.didStartLoading()
         // Call the authentication function from AuthenticationManager
        authenticationManager.signIn(withPhoneNumber: phoneNumber) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.didFinishLogin()
            case .failure(let error):
                self?.delegate?.didFail(withError: error)
            }
            
            self?.delegate?.didFinishLoading()
        }
    }
}
