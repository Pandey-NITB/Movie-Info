//
//  MovieInfoAppNavigationRouter.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 02/09/22.
//

import Foundation
import UIKit

protocol NavigationDelegate {
    associatedtype MovieAppView
    func dismissView(animated: Bool)
    func popView(animated: Bool)
    func presentView(_ view: MovieAppView, animated: Bool)
    func pushView(_ view: MovieAppView, animated: Bool)
    func setRootView(_ view: MovieAppView, animated: Bool)
}

final class MovieInfoAppNavigationRouter<Factory: ViewComposerFactory, Navigation: NavigationDelegate> where Factory.MovieAppView == Navigation.MovieAppView {
    private var factory: Factory
    private var navigationResolver: () -> Navigation

    init(factory: Factory, navigationResolver: @escaping () -> Navigation) {
        self.factory = factory
        self.navigationResolver = navigationResolver
    }
    
    func dismissView(animated: Bool = true) {
        navigation.dismissView(animated: animated)
    }
    
    func popView(animated: Bool = true) {
        navigation.popView(animated: animated)
    }
    
    func presentView(type: MovieInfoAppViewType, animated: Bool = true) {
        navigation.presentView(factory.composeView(type: type), animated: animated)
    }
    
    func pushView(type: MovieInfoAppViewType, animated: Bool = true) {
        navigation.pushView(factory.composeView(type: type), animated: animated)
    }
    
    func setRootView(type: MovieInfoAppViewType, animated: Bool = true) {
        navigation.setRootView(factory.composeView(type: type), animated: animated)
    }
}

extension MovieInfoAppNavigationRouter {
    private var navigation: Navigation {
        navigationResolver()
    }
    
    var viewFactory: MovieInfoViewControllerFactory {
        factory as! MovieInfoViewControllerFactory
    }
    
    var navigationController: UINavigationController {
        navigation as! UINavigationController
    }
}
