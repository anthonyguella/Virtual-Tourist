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

@objc(Pin)
public class Pin: NSManagedObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
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
    

}
