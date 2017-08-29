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
    
    
    //MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK: Variables
    var photo: Photo? {
        didSet {
            setImage()
        }
    }
    
    func setImage() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
        }
        if photo!.imageData != nil {
                DispatchQueue.main.async {
                self.imageView.image = UIImage(data: self.photo!.imageData! as Data)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        } else {
            downloadImage(photo!)
        }
    }
    
    func downloadImage(_ photo: Photo) {
        
        NetworkConvenience.sharedInstance().session.dataTask(with: URL(string: photo.url!)!) { (data, response, error) in
            if error == nil {
                 DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data!)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            }
            
        }.resume()
    }
    
    func saveImage() {
        let image = self.imageView.image
        photo!.imageData = UIImagePNGRepresentation(image!)! as NSData
        DatabaseController.saveContext()
    }
}
