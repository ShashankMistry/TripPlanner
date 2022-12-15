//
//  ViewController.swift
//  FinalCapstoneGroup6
//
//  Created by user213797 on 12/4/22.
//

import UIKit
import CoreData

class ViewController: UITableViewController, sendData {
    func sendDataToMainVC(vacation: TripPlan) {
        //using protocal to receive data back from AddVacationVC
        tripList.plan.insert(vacation, at: 0) //adding new elements at index zero so user can see last planned vacation at the top
        tableView.reloadData() //reloading tableView after adding data to trip array
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    var fistLoad = true
    
    var tripList : tripPlanList!

    override func viewDidLoad() {
        super.viewDidLoad()
        //checking for first load to load data from CoreData
        if(fistLoad){
            let appDeleget = UIApplication.shared.delegate as! AppDelegate
            let context : NSManagedObjectContext = appDeleget.persistentContainer.viewContext; //gettign context for coredata
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TripPlan") //requesting stored data from coreadta
            do {
                print("do")
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    tripList.plan.insert(result as! TripPlan, at: 0) //adding feched data into array
                    tableView.reloadData()
                    print("working")
                    fistLoad = false
                }
                
            }
            catch {
            print( "Fetch Failed")
            }
        }
        // Do any additional setup after loading the view.
        
    }
    
    //prepare function to give context to protocol and send data to DetailedVacationVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let VC = segue.destination as? AddVacationVC{
            VC.sendDeleget = self //seting self to protocol to get data
        }
        //identifying segue with idedntifier
        if segue.identifier == "detailedVC" {
            if let row = tableView.indexPathForSelectedRow?.row {
            let trip = tripList.plan[row]
            let detailedVC = segue.destination as! DetailedVacationVC
                detailedVC.vacation = trip //setting data to next VC
    
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)->Int {
       
        return tripList.plan.count //setting max number of rows in tableView with list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! tripCell //getting cell properties after casting it to tripCell
        
        let item = tripList.plan[indexPath.row] //fetching item from particular cell data
        
        cell.locationLabel.text = item.location //setting text to labels in cell
        cell.noteLabel.text = "\(item.note!)"
        return cell
    }
    
    //code to delete item from table view
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = tripList.plan[indexPath.row]
            
            let title = "\(NSLocalizedString("Delete", comment: "delete string")) \(item.location!)?"
            let message = NSLocalizedString("warning", comment: "warning que")
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "cancel string"), style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: "delete string"), style: .destructive, handler:
            {(action)->Void in
                let appDeleget = UIApplication.shared.delegate as! AppDelegate
                let context : NSManagedObjectContext = appDeleget.persistentContainer.viewContext;
                context.delete(item) //deleting particular item from coredata
                appDeleget.saveContext() //saving context to remeber changes
                self.tripList.remove(item)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            ac.addAction(deleteAction)
            present(ac, animated: true, completion: nil)
        }
    }
    
    

}

