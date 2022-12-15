//
//  ImageViewCell.swift
//  FinalCapstoneGroup6
//
//  Created by user213797 on 12/6/22.
//

import UIKit

class ImageViewCell : UICollectionViewCell {
    //creating UI elements to access them in collection view cell
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var loader: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        startStopLoader(with: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        startStopLoader(with: nil)
    }
    
    //stops loader
    func startStopLoader(with image: UIImage?) {
        imageView.contentMode = .scaleAspectFill;
        imageView.clipsToBounds = true;
        if let imageToDisplay = image {
            imageView.image = imageToDisplay
            loader.stopAnimating()
            loader.hidesWhenStopped = true
        } else {
            loader.startAnimating()
            imageView.image = nil
        }
    }
}
