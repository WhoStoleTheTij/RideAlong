//
//  Photo+CoreDataClass.swift
//  RideAlong
//
//  Created by Richard H on 07/08/2017.
//  Copyright © 2017 Richard H. All rights reserved.
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {
    convenience init(latitude: Double, longitude: Double, context: NSManagedObjectContext){
        
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context){
            self.init(entity:ent, insertInto:context)
            self.latitude = latitude
            self.longitude = longitude
        }else{
            fatalError("Unable to find entity name")
        }
        
        
    }
}
