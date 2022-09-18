//
//  MovieDetailViewController.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 28/08/22.
//

import Foundation
import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var voteAvarageLabel: UILabel!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!

    private var viewModel: MovieDetailViewModel!
    
    var isFavorite = false
    
    convenience init(viewModel: MovieDetailViewModel) {
        self.init(nibName: Constants.movieDetailVCTIdentifier, bundle: nil)
        self.viewModel = viewModel
        self.viewModel.viewDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchMovieDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        createFavoriteButton()
    }
    
    private func createFavoriteButton() {
        var imageName = ""
        if viewModel.isMovieFav(for: (viewModel.movieId as NSString).integerValue) {
            imageName = "icon_fav_selelcted"
            self.isFavorite = true
        } else {
            imageName =  "icon_fav"
            self.isFavorite = false
        }
        let button = UIBarButtonItem(
            image: UIImage(named: imageName)?.withTintColor(.green),
            style: .plain,
            target: self,
            action: #selector(favoriteMovie))
        
        let shareButton = UIBarButtonItem(
            image:  UIImage(named: "icon_share")?.withTintColor(.green),
            style: .plain,
            target: self,
            action: #selector(shareMovie))
        
        self.navigationItem.rightBarButtonItems = [button, shareButton]
        self.view.layoutIfNeeded()
    }
    
    @objc func favoriteMovie() {
        if self.isFavorite {
            self.navigationItem.rightBarButtonItems?[0].image = UIImage(named: "icon_fav")
            self.isFavorite = false
        } else {
            self.isFavorite = true
            self.navigationItem.rightBarButtonItems?[0].image = UIImage(named: "icon_fav_selelcted")
        }
        viewModel.favButtonClicked(id: (viewModel.movieId as NSString).integerValue)
    }
    
    @objc func shareMovie() {
        let deeplink = "demoapp://api.themoviedb.org/3/movie/" + viewModel.movieId
        let shareText = "Hey I am sharing you this movie please click on the link below"
        let shareAll = [shareText, deeplink] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func updateUI() {
        titleLabel.text = viewModel.getMovieTitle()
        if let releaseDate = viewModel.getMovieReleaseData() {
            releaseDateLabel.text = "Release Date: " + releaseDate
        }
      
        if let vote = viewModel.getMovieAvgVotes() {
            voteAvarageLabel.text = "Rating: " +  vote
        }
        
        if let overView = viewModel.getMovieOverView() {
            overviewLabel.text = "OverView: \n" + overView
        }
       
        if !viewModel.getMoviePosterPathString().isEmpty {
            if let imageUrl = URL(string: viewModel.getMoviePosterPathString()) {
                ImageLoader.shared.loadImage(from: imageUrl) { (image) in
                    
                    if let movieImage = image {
                        DispatchQueue.main.async {
                            self.itemImageView.image = movieImage
                        }
                    }
                }
            }
        }
    }
}

extension MovieDetailViewController: ResponseViewAdapter {
    func onSuccess() {
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
    
    func showError(message: String) {
        print("error message is \(message)")
    }
}
