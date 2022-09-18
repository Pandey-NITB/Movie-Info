//
//  TabBarController.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 28/08/22.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func initialise(_ controllers: [UIViewController]) {
        self.viewControllers = controllers
        self.selectedViewController = controllers.first
        self.selectedIndex = 0
        self.tabBar.barStyle = .black
        self.tabBar.tintColor = Constants.color().lightGreen
        self.tabBar.unselectedItemTintColor = .white
        
    }
    
}
