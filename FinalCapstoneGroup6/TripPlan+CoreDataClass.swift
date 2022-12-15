//
//  TripPlan+CoreDataClass.swift
//  FinalCapstoneGroup6
//
//  Created by user213797 on 12/10/22.
//
//

import Foundation
import CoreData


public class TripPlan: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = 0;
        lat = 0.0;
        lng = 0.0;
        location = "";
        note = "";
        numnberOfPeople = 0;
    }
}
