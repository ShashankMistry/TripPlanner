//
//  tripPlanList.swift
//  FinalCapstoneGroup6
//
//  Created by user213797 on 12/6/22.
//

import UIKit

class tripPlanList {

    
    
    var plan : [TripPlan] = []

    //remove item from tableView
    func remove(_ leg: TripPlan) {
        if let index = plan.firstIndex(of: leg) {
            plan.remove(at: index)
        }
    }
    
    //arranging items in table View
    func arrangeItems(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        let movedItem = plan[fromIndex]
        plan.remove(at: fromIndex) //remove item from that index
        plan.insert(movedItem, at: toIndex) //and add it to new index
    }
    
    
}

