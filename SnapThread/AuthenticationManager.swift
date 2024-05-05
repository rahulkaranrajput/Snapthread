//
//  AuthenticationManager.swift
//  SnapThread
//
//  Created by Rahul K on 30/04/24.
//

import Foundation
import FirebaseAuth

class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    private init() {}
    
    typealias AuthenticationCompletion = (Result<User, Error>) -> Void
    
    // Function to sign in with phone number
    func signIn(withPhoneNumber phoneNumber: String, completion: @escaping AuthenticationCompletion) {
        // Start the phone authentication process
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            // Save the verification ID for later use
            print("authVerificationID",verificationID)
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            completion(.success(User(phoneNumber: phoneNumber)))
        }
    }
    
    // Function to verify the entered OTP and complete the sign in process
    func verifyOTP(_ otp: String, completion: @escaping AuthenticationCompletion) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            let error = NSError(domain: "AuthenticationManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Verification ID not found."])
            completion(.failure(error))
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: otp)
        Auth.auth().signIn(with: credential) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let user = result?.user {
                completion(.success(User(phoneNumber: user.phoneNumber ?? "")))
            } else {
                let error = NSError(domain: "AuthenticationManager", code: -2, userInfo: [NSLocalizedDescriptionKey: "User not found."])
                completion(.failure(error))
            }
        }
    }
    
    // Function to sign out the current user
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

// Custom User model
struct User {
    let phoneNumber: String
}
