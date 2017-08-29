//
//  Photo+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Anthony Guella on 8/25/17.
//  Copyright © 2017 Anthony Guella. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var imageData: NSData?
    @NSManaged public var url: String?
    @NSManaged public var pin: Pin?

}
