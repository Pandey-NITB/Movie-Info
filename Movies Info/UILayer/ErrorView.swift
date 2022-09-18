//
//  ErrorView.swift
//  Tmdb Movies
//
//  Created by Prashant Pandey on 07/09/22.
//

import Foundation
import UIKit

class ErrorView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            self.imageView.image = UIImage(named: "ic_sad")?.withTintColor(.white)
        }
    }
    
    @IBOutlet weak var errorLabel: UILabel! {
        didSet {
            self.errorLabel.backgroundColor = .clear
            self.errorLabel.textColor = .white
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .black
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed("ErrorView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func updateErrorLabel(text: String) {
        self.errorLabel.text = text
    }
}
