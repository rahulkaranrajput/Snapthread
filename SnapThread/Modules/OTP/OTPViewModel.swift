//
//  OTPViewModel.swift
//  SnapThread
//
//  Created by Rahul K on 01/05/24.
//

import Foundation

protocol OTPViewModelDelegate: AnyObject {
    func didStartLoading()
    func didFinishLoading()
    func didVerifyOTP()
    func didFail(withError error: Error)
}

class OTPViewModel {
    
    // MARK: - Properties
    
    weak var delegate: OTPViewModelDelegate?
    
    // MARK: - Initialization
    
    init(delegate: OTPViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - OTP Verification
    
    func verifyOTP(_ otp: String) {
        // Simulate loading state
        delegate?.didStartLoading()
        // Use AuthenticationManager to verify OTP
        AuthenticationManager.shared.verifyOTP(otp) { [weak self] result in
            guard let self = self else { return }
            // Handle the result from the AuthenticationManager
            switch result {
            case .success:
                // OTP verification succeeded
                self.delegate?.didVerifyOTP()
            case .failure(let error):
                // OTP verification failed
                self.delegate?.didFail(withError: error)
            }
            // Simulate completion of loading state
            self.delegate?.didFinishLoading()
        }
    }
}

