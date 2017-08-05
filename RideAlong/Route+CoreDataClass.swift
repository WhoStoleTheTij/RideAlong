//
//  Route+CoreDataClass.swift
//  RideAlong
//
//  Created by Richard H on 05/08/2017.
//  Copyright © 2017 Richard H. All rights reserved.
//

import Foundation
import CoreData

@objc(Route)
public class Route: NSManagedObject {
    convenience init(name: String, context: NSManagedObjectContext){
        
        if let ent = NSEntityDescription.entity(forEntityName: "Route", in: context){
            self.init(entity: ent, insertInto: context)
            self.name = name
        }else{
            fatalError("Unable to find entity name")
        }
        
    }
}
