//
//  FavouriteMoviesListViewController.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 07/09/22.
//

import Foundation
import UIKit

class FavouriteMoviesListViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = Constants.favMovieText
        }
    }
    
    @IBOutlet weak var movieItemView: MovieItemsView!
    
    @IBOutlet weak var errorView: ErrorView!
    
    private  var viewModel: FavouriteMoviesListViewModel!
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    convenience init(viewModel: FavouriteMoviesListViewModel) {
        self.init(nibName: Constants.favVCIdentifier, bundle: nil)
        self.viewModel = viewModel
        self.viewModel.viewDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movieItemView.delegate = self
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.viewModel.fetchFavMovies()
        setNeedsStatusBarAppearanceUpdate()
    }
}

extension FavouriteMoviesListViewController: ResponseViewAdapter {
    func onSuccess() {
        DispatchQueue.main.async {
            self.movieItemView.dataSource = self.viewModel.getMovieReaults()
            self.movieItemView.collectionView.reloadData()
        }
    }
   
    func showError(message: String) {
        DispatchQueue.main.async {
            print("message is \(message)")
            self.movieItemView.isHidden = true
            self.errorView.updateErrorLabel(text: message)
            self.view.bringSubviewToFront(self.errorView)
            self.errorView.isHidden = false
        }
    }
}

extension FavouriteMoviesListViewController : MovieItemViewDelegate {
    func didSelectedOnMovieItem(movie: MovieItem) {
        let router = (UIApplication.shared.delegate as! AppDelegate).navigationRouter
        router.pushView(type: .movieDetail("\(movie.id)"))
    }
    
    func loadMoreData() {}
}
