//
//  RootWireFrame.swift
//  TestTask
//
//  Created by Green on 16.11.2022.
//

import UIKit

final class RootWireFrame {
   static func create(window: UIWindow?, scene: UIWindowScene) {
        let mainTabBar = TabBarViewController()
        window?.windowScene = scene
        window?.rootViewController = mainTabBar
        window?.makeKeyAndVisible()
    }
}
