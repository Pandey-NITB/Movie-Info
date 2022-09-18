//
//  SearchViewController.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 28/08/22.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            setupSearchBar()
        }
    }
    
    private  var viewModel:  SearchViewModel!
    private var queryText: String!
    private var searchWorkItem: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @IBOutlet weak var movieItemsView: MovieItemsView!
    
    convenience init(viewModel: SearchViewModel) {
        self.init(nibName: "SearchViewController", bundle: nil)
        self.viewModel = viewModel
        self.viewModel.viewDelegate = self
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.clearBackgroundColor()
        searchBar.layer.borderWidth = 1.0
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.textField?.backgroundColor = .clear
        searchBar.textField?.placeholder = Constants.searchPlaceholderText
        searchBar.changePlaceholderColor(.red)
        searchBar.textField?.textColor = .white
        searchBar.textField?.keyboardAppearance = .dark
        searchBar.textField?.returnKeyType = .done
        searchBar.textField?.tintColor = .red
        searchBar.textField?.delegate = self
        searchBar.backgroundImage = UIImage(color: .black, size: CGSize(width: searchBar.frame.width, height: searchBar.frame.height))
        searchBar.setLeftImage((UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate))!, tintColor: .red)
    }
    
    private func setupUI() {
        self.movieItemsView.collectionView.isHidden = true
        self.movieItemsView.delegate = self
        self.view.backgroundColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        setNeedsStatusBarAppearanceUpdate()
    }
}

extension SearchViewController {
    func searchText(text: String) {
        viewModel.removePreviousSearchResults()
        viewModel.fetchMovieListWith(text: text, page: viewModel.getCurrentPageIndex())
    }
}


extension SearchViewController: ResponseViewAdapter {
    func onSuccess() {
        if viewModel.getNumberOfMovieItems() > 0 {
            DispatchQueue.main.async {
               self.movieItemsView.dataSource = self.viewModel.getMovieReaults()
            //    self.movieItemsView.movieItemModel = self.viewModel.getMovieModel()
                self.movieItemsView.collectionView.isHidden = false
                self.movieItemsView.collectionView.reloadData()
            }
        }
    }
    
    func showError(message: String) {
        print("error is \(message)")
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.queryText = searchText
        if !searchText.isEmpty {
            print("searchText is \(searchText)")
            
            self.searchWorkItem?.cancel()
            self.searchWorkItem = DispatchWorkItem {
                print("under work item \(searchText)")
                self.searchText(text: searchText)
            }
            
            DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.8, execute:self.searchWorkItem!)
        
        } else {
            self.movieItemsView.collectionView.isHidden = true
            self.searchWorkItem?.cancel()
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.searchWorkItem?.cancel()
        return true
    }
}

extension SearchViewController: MovieItemViewDelegate {
    func didSelectedOnMovieItem(movie: MovieItem) {
        let router = (UIApplication.shared.delegate as! AppDelegate).navigationRouter
        router.pushView(type: .movieDetail("\(movie.id)"))
    }
    
    func loadMoreData() {
        self.viewModel.fetchMovieListWith(text: queryText, page: viewModel.getCurrentPageIndex() + 1)
    }
}
