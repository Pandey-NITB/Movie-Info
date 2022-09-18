//
//  UINavigationControllerExtension.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 02/09/22.
//

import Foundation
import UIKit

extension UINavigationController: NavigationDelegate  {
    func dismissView(animated: Bool) {
        self.visibleViewController?.dismiss(animated: animated)
    }
    
    func popView(animated: Bool) {
        self.popViewController(animated: animated)
    }
    
    func presentView(_ view: UIViewController, animated: Bool) {
        self.visibleViewController?.present(view, animated: animated)
    }
    
    func pushView(_ view: UIViewController, animated: Bool) {
        self.pushViewController(view, animated: animated)
    }
    
    func setRootView(_ view: UIViewController, animated: Bool) {
        self.navigationBar.isHidden = true
        self.setViewControllers([view], animated: false)
        if animated {
            UIView.transition(with: (UIApplication.shared.delegate as! AppDelegate).window!, duration: 0.3, options: .transitionCrossDissolve) {
                (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController = self
            }
        } else {
            (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController = self
        }
        (UIApplication.shared.delegate as! AppDelegate).window!.makeKeyAndVisible()
    }
}
