//
//  Photo+CoreDataProperties.swift
//  RideAlong
//
//  Created by Richard H on 07/08/2017.
//  Copyright © 2017 Richard H. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var route: Route?

}
