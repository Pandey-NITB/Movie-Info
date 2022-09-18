//
//  TrendingMoviesViewController.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 23/08/22.
//

import Foundation
import UIKit

class TrendingMoviesViewController: UIViewController {
    
    @IBOutlet weak var movieItemView: MovieItemsView!
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private var viewModel: TrendingMoviesViewModel!
    
    convenience init(viewModel: TrendingMoviesViewModel) {
        self.init(nibName: "TrendingMoviesViewController", bundle: nil)
        self.viewModel = viewModel
        self.viewModel.viewDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.movieItemView.delegate = self
        viewModel.fetchTrendingMovies(page: viewModel.getCurrentPageIndex())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        setNeedsStatusBarAppearanceUpdate()
    }
}

extension TrendingMoviesViewController: ResponseViewAdapter {
    func onSuccess() {
        DispatchQueue.main.async {
            self.movieItemView.dataSource = self.viewModel.getMovieReaults()
            self.movieItemView.collectionView.reloadData()
        }
    }
    
    func showError(message: String) {
        print("error is \(message)")
    }
}

extension TrendingMoviesViewController: MovieItemViewDelegate {
    func didSelectedOnMovieItem(movie: MovieItem) {
        let router = (UIApplication.shared.delegate as! AppDelegate).navigationRouter
        router.pushView(type: .movieDetail("\(movie.id)"))
    }
    
    func loadMoreData() {
        self.viewModel.fetchTrendingMovies(page: viewModel.getCurrentPageIndex() + 1)
    }
}
