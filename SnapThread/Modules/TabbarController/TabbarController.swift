//
//  TabbarController.swift
//  SnapThread
//
//  Created by Rahul K on 30/04/24.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up HomeViewController
        let homeVC = HomeViewController()
        homeVC.title = "Home"
        let homeNavController = UINavigationController(rootViewController: homeVC)
        homeNavController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        // Set up CreatePostViewController
        let createPostVC = CreatePostViewController()
        createPostVC.title = "Create Post"
        let createPostNavController = UINavigationController(rootViewController: createPostVC)
        createPostNavController.tabBarItem = UITabBarItem(title: "Create Post", image: UIImage(systemName: "plus.square"), selectedImage: UIImage(systemName: "plus.square.fill"))
        
        // Set up TabBarController with the two view controllers
        viewControllers = [homeNavController, createPostNavController]
    }
}
