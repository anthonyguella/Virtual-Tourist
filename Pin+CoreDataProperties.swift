//
//  Pin+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Anthony Guella on 8/23/17.
//  Copyright © 2017 Anthony Guella. All rights reserved.
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var photo: NSOrderedSet?

}

// MARK: Generated accessors for photo
extension Pin {

    @objc(insertObject:inPhotoAtIndex:)
    @NSManaged public func insertIntoPhoto(_ value: Photo, at idx: Int)

    @objc(removeObjectFromPhotoAtIndex:)
    @NSManaged public func removeFromPhoto(at idx: Int)

    @objc(insertPhoto:atIndexes:)
    @NSManaged public func insertIntoPhoto(_ values: [Photo], at indexes: NSIndexSet)

    @objc(removePhotoAtIndexes:)
    @NSManaged public func removeFromPhoto(at indexes: NSIndexSet)

    @objc(replaceObjectInPhotoAtIndex:withObject:)
    @NSManaged public func replacePhoto(at idx: Int, with value: Photo)

    @objc(replacePhotoAtIndexes:withPhoto:)
    @NSManaged public func replacePhoto(at indexes: NSIndexSet, with values: [Photo])

    @objc(addPhotoObject:)
    @NSManaged public func addToPhoto(_ value: Photo)

    @objc(removePhotoObject:)
    @NSManaged public func removeFromPhoto(_ value: Photo)

    @objc(addPhoto:)
    @NSManaged public func addToPhoto(_ values: NSOrderedSet)

    @objc(removePhoto:)
    @NSManaged public func removeFromPhoto(_ values: NSOrderedSet)

}
