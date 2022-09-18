//
//  MovieItemView.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 07/09/22.
//

import Foundation
import UIKit

protocol MovieItemViewDelegate: AnyObject {
    func didSelectedOnMovieItem(movie: MovieItem)
    func loadMoreData()
}

class MovieItemsView: UIView {
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            setupCollectionView()
        }
    }
    
    var dataSource: [MovieItem]!
    
    weak var delegate: MovieItemViewDelegate?
    
    private func setup() {
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed("MovieItemsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCellNib(MovieItemCollectionViewCell.self)
        let itemWidth = UIScreen.main.bounds.width/2 - 24
        let heightProportion = CGFloat(1.83)
        let itemHeight = itemWidth * heightProportion

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)

        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 30

        collectionView.collectionViewLayout = layout
    }
}

extension MovieItemsView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let moviesCell = collectionView.dequeueCell(MovieItemCollectionViewCell.self, at: indexPath)
        
        if dataSource.count > 0 {
            moviesCell.configureCellWith(movieItem: dataSource[indexPath.row])
        }
    
        return moviesCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectedOnMovieItem(movie: dataSource[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let movieResults = dataSource, movieResults.count > 0 {
            if indexPath.row == dataSource.count - 1 {
                delegate?.loadMoreData()
            }
        }
    }
}
