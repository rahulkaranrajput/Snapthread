//
//  AppNavigator.swift
//  SnapThread
//
//  Created by Rahul K on 30/04/24.
//

import UIKit
import FirebaseAuth

import UIKit
import FirebaseAuth

class AppNavigator {
    
    static let shared = AppNavigator()
    private var window: UIWindow?
    private var navigationController: UINavigationController?
    private var tabBarController: UITabBarController?
    
    private init() {
        
    }
    
    func start(with window: UIWindow?) {
        guard let window = window else { return }
        self.window = window
        
        if Auth.auth().currentUser != nil {
            // User is already logged in
            showTabBarController()
        } else {
            // User is not logged in
            showLoginViewController()
        }
    }
    
    private func showLoginViewController() {
        let loginViewController = LoginViewController()
        navigationController = UINavigationController(rootViewController: loginViewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func showTabBarController() {
        let homeVC = HomeViewController()
        homeVC.title = "Home"
        let homeNavController = UINavigationController(rootViewController: homeVC)
        homeNavController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        let createPostVC = CreatePostViewController()
        createPostVC.title = "Create Post"
        let createPostNavController = UINavigationController(rootViewController: createPostVC)
        createPostNavController.tabBarItem = UITabBarItem(title: "Create Post", image: UIImage(systemName: "plus.square"), selectedImage: UIImage(systemName: "plus.square.fill"))
        
        tabBarController = UITabBarController()
        tabBarController?.viewControllers = [homeNavController, createPostNavController]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
