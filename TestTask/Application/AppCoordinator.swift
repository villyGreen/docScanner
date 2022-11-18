//
//  AppCoordinator.swift
//  TestTask
//
//  Created by Green on 18.11.2022.
//

import UIKit

final class AppCoordinator {
    private var window: UIWindow?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    /// Start launch screen
    func start() {
        let mainTabBar = TabBarViewController()
        window?.rootViewController = mainTabBar
        window?.makeKeyAndVisible()
    }
}
