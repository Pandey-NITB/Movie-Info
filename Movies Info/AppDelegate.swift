//
//  AppDelegate.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 18/08/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    var navigationVC: UINavigationController!
    
    lazy var navigationRouter: MovieInfoAppNavigationRouter<MovieInfoViewControllerFactory, UINavigationController> = {
        MovieInfoAppNavigationRouter(factory: MovieInfoViewControllerFactory()) {
            self.navigationVC
        }
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.initWindow(launchOptions: launchOptions)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true), let _ = components.host else {
            return false
        }
        
        if let deepLinkUrl = components.url {
            if let movieInfoType = DeepLinkParser.parse(urlString: deepLinkUrl) {
                self.navigationRouter.pushView(type: movieInfoType)
            }
        }
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
      
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
      
    }

}

extension AppDelegate {
    private func createNavigation(with viewController: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigation.navigationBar.titleTextAttributes = textAttributes
        navigation.navigationBar.largeTitleTextAttributes = textAttributes
        navigation.navigationBar.barStyle = .black
        navigation.navigationBar.tintColor = .white
        navigation.setNavigationBarHidden(true, animated: false)

        return navigation
    }
}

extension AppDelegate {
    func initWindow(launchOptions: [AnyHashable: Any]?) {
        window = UIWindow(frame: UIScreen.main.bounds)
        let controller = TabBarController()
        let controllersList = [ self.navigationRouter.viewFactory.composeView(type: .playingNow),
                                self.navigationRouter.viewFactory.composeView(type: .trendingMovies),
                              self.navigationRouter.viewFactory.composeView(type: .search),
                                self.navigationRouter.viewFactory.composeView(type: .favMovies)
                               ]
        
        controller.initialise(controllersList)
        self.navigationVC = self.createNavigation(with: controller)
        window?.rootViewController = self.navigationVC
        window?.makeKeyAndVisible()
    }
}




