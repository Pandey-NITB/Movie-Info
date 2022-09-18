//
//  NowPlayingMoviesViewController.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 28/08/22.
//

import Foundation
import UIKit

class NowPlayingMoviesViewController: UIViewController {
    
    @IBOutlet weak var movieItemsView: MovieItemsView!
    
//    private lazy var viewModel: NowPlayingMoviesViewModelType = NowPlayingMoviesViewModel(viewDelegate: self)
    
    private var viewModel: NowPlayingMoviesViewModel!
    
    convenience init(viewModel: NowPlayingMoviesViewModel) {
        self.init(nibName: "NowPlayingMoviesViewController", bundle: nil)
        self.viewModel = viewModel
        self.viewModel.viewDelegate = self
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchNowPlayingMovies(page: viewModel.getCurrentPageIndex())
        movieItemsView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        setNeedsStatusBarAppearanceUpdate()
    }
}

extension NowPlayingMoviesViewController: ResponseViewAdapter {
    func onSuccess() {
        DispatchQueue.main.async {
            self.movieItemsView.dataSource = self.viewModel.getMovieReaults()
            self.movieItemsView.collectionView.reloadData()
        }
    }
    
    func showError(message: String) {
        print("error is \(message)")
    }
}

extension NowPlayingMoviesViewController: MovieItemViewDelegate {
    func didSelectedOnMovieItem(movie: MovieItem) {
        let router = (UIApplication.shared.delegate as! AppDelegate).navigationRouter
        router.pushView(type: .movieDetail("\(movie.id)"))
    }
    
    func loadMoreData() {
        self.viewModel.fetchNowPlayingMovies(page: viewModel.getCurrentPageIndex() + 1)
    }
}
