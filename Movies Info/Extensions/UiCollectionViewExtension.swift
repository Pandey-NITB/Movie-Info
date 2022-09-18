//
//  UiCollectionViewExtension.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 28/08/22.
//
import UIKit
extension UICollectionView {
    func dequeueCell<T: UICollectionViewCell>(_ type: T.Type, at indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: String(describing: type.self), for: indexPath) as! T
    }
    
    func registerCell<T: UICollectionViewCell>(_ type: T.Type) {
        register(type, forCellWithReuseIdentifier: String(describing: type.self))
    }
    
    func registerCellNib<T: UICollectionViewCell>(_ type: T.Type) {
        register(UINib(nibName: String(describing: type.self), bundle: .main), forCellWithReuseIdentifier: String(describing: type.self))
    }
}
