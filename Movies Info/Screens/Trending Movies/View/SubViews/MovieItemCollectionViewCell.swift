//
//  MovieItemCollectionViewCell.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 28/08/22.
//

import Foundation
import UIKit

class MovieItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Object lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.numberOfLines = 2
    }
    
    func configureCellWith(movieItem: MovieItem) {
        titleLabel.text = movieItem.title
        yearLabel.text = "".formatedReleaseDate(movieItem.relaseDate)
        if !movieItem.posterPath.isEmpty {
            if let imageUrl = URL(string: Constants.smallPosterPath + movieItem.posterPath) {
                ImageLoader.shared.loadImage(from: imageUrl) { (image) in
                    if let movieImage = image {
                        DispatchQueue.main.async {
                            self.imageView.image = movieImage
                        }
                    }
                }
            }
        }
    }
}
