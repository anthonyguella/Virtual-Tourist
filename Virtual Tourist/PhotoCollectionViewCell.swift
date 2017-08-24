//
//  PhotoCollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Anthony Guella on 8/23/17.
//  Copyright © 2017 Anthony Guella. All rights reserved.
//

import Foundation
import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var photo: Photo? = nil {
        didSet {
            loading = true
            photo?.start
            
        }
    }
   
    var loading: Bool {
        set {
            if newValue {
                imageView.image = nil
                activityIndicator.startAnimating()
                activityIndicator.isHidden = false
            } else {
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
            }
        }
        get {
            return !activityIndicator.isHidden
        }
    }
}
