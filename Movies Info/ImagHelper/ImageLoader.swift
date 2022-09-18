//
//  ImageLoader.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 18/08/22.
//

import Foundation
import UIKit

typealias ImageCompletion = (UIImage?) -> ()

final class ImageLoader {
    static let shared = ImageLoader()
    private let cache = CustomCache<String, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    private init() {
    }
    
    func loadImage(from url: URL, completion: @escaping ImageCompletion) {
        if let cachedImage = self.cache.value(forKey: url.absoluteString) {
            debugPrint("cached image from \(url.absoluteString)")
            completion(cachedImage)
        }
        
        utilityQueue.async {
            guard let data = try? Data(contentsOf: url) else {
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                completion(image)
            }
            
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                    self.cache.setValue(image, forKey: url.absoluteString)
                }
            } else {
                completion(nil)
            }
        }
    }
}

