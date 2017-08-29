//
//  Pin+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Anthony Guella on 8/23/17.
//  Copyright © 2017 Anthony Guella. All rights reserved.
//

import Foundation
import CoreData
import MapKit

public class Pin: NSManagedObject, MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D {
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(latitude: Double, longitude: Double, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Pin", in: context)
        super.init(entity: entity!, insertInto: context)
        
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func getNewPhotos(context: NSManagedObjectContext) {
        
        let photos = Flickr.sharedInstance().getFlickrImagesFromSearch(lat: self.latitude, lon: self.longitude, nil) { (photos, error) in
            
            guard error == nil else {
                print(error)
                return
            }
            
            guard photos != nil else {
                print("No images found")
                return
            }
            
            for photo in photos! {
                let url = photo["url_m"] as! String
                let photo = Photo(pin: self, url: url, context: context)
                do{
                    try DatabaseController.saveContext()
                }
                catch {
                }
                
                    
            }
            return
        }
    }
}
