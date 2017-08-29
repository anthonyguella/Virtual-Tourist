//
//  Photo+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Anthony Guella on 8/25/17.
//  Copyright © 2017 Anthony Guella. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class Photo: NSManagedObject {
    
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(pin: Pin, url: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Photo", in: context)
        super.init(entity: entity!, insertInto: context)
        
        self.pin = pin
        self.url = url
  
    }


}
