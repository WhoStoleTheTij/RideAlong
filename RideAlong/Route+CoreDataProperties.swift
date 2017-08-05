//
//  Route+CoreDataProperties.swift
//  RideAlong
//
//  Created by Richard H on 05/08/2017.
//  Copyright © 2017 Richard H. All rights reserved.
//

import Foundation
import CoreData


extension Route {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Route> {
        return NSFetchRequest<Route>(entityName: "Route")
    }

    @NSManaged public var points: NSArray?
    @NSManaged public var name: String?
    @NSManaged public var photos: NSSet?

}

// MARK: Generated accessors for photos
extension Route {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}
