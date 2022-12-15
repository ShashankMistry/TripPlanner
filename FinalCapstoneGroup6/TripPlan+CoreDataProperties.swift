//
//  TripPlan+CoreDataProperties.swift
//  FinalCapstoneGroup6
//
//  Created by user213797 on 12/10/22.
//
//

import Foundation
import CoreData


extension TripPlan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TripPlan> {
        return NSFetchRequest<TripPlan>(entityName: "TripPlan")
    }

    @NSManaged public var id: Int32
    @NSManaged public var lat: Double
    @NSManaged public var lng: Double
    @NSManaged public var location: String?
    @NSManaged public var note: String?
    @NSManaged public var numnberOfPeople: Int32

}

extension TripPlan : Identifiable {

}
