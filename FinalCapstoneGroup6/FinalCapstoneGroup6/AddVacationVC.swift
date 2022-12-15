//
//  AddVacationVC.swift
//  FinalCapstoneGroup6
//
//  Created by user213797 on 12/4/22.
//

import UIKit
import MapKit
import CoreData

protocol sendData {
    func sendDataToMainVC(vacation : TripPlan) //craeted protocal to send data to previous Viewcontroller
}

class AddVacationVC: UIViewController, MKMapViewDelegate {
    
    var sendDeleget : sendData?
    var vacation : TripPlan!
    var context : NSManagedObjectContext!

    override func viewDidLoad() {
        let appDeleget = UIApplication.shared.delegate as! AppDelegate //getting app delegate to access coredata context
        context = appDeleget.persistentContainer.viewContext; //getting context
        let entity = NSEntityDescription.entity(forEntityName: "TripPlan", in: context) //getting entity as name in xcdatamodel file
        vacation = TripPlan(entity: entity!, insertInto: context) //passing entity and context to initialize obj
        super.viewDidLoad()
        mapView.delegate = self //setting map view to put markers
        let tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(tap(sender:)))  //assigning tap gesture recogniser to map to recon taps
        mapView.addGestureRecognizer(tapRecogniser)
        let interaction = UIContextMenuInteraction(delegate: self) //adding context menu on long click on maps
        mapView.addInteraction(interaction)
    }
    
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var ErrorLabel: UILabel!
    
    @IBOutlet weak var LocationField: UITextField!
    @IBOutlet weak var NumField: UITextField!
    @IBOutlet weak var NoteField: UITextField!
    
    
    
    //save button action
    @IBAction func didTapSave(){
       //checking if any field is empty or not
        if let location = LocationField.text, let note = NoteField.text, let num = Int(NumField.text!) {
            vacation.id = Int32(num)
            vacation.location = location.trimmingCharacters(in: .whitespacesAndNewlines);
            vacation.note = note;
            vacation.numnberOfPeople = Int32(num);
            do{
                //saving data ot coredata
            try  context.save()
            } catch {
                print("data not saved error")
            }
            sendDeleget?.sendDataToMainVC(vacation: vacation) //passing data to protocol
            self.navigationController?.popViewController(animated: true) //pop view controller to show previous controller
        } else {
            ErrorLabel.text = NSLocalizedString("ent_all", comment: "warning")
        }
        
        
    }
    
  
    
        @IBOutlet weak var mapView: MKMapView!
    
    
        @IBAction func dismissKeyboard(_ sender: Any) {
            view.endEditing(true) //dismiss keyboards
        }


    
//tap recognizer for tap recogniser of map
    @objc func tap(sender: UIGestureRecognizer){
            print("tap")
            view.endEditing(true)
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            addAnnotation(location: locationOnMap) //adding anotation on map where user touches
    }

    func addAnnotation(location: CLLocationCoordinate2D){
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = NSLocalizedString("vc_spot", comment: "spot")
            self.mapView.addAnnotation(annotation) //annotation
            vacation.lat = location.latitude
            vacation.lng = location.longitude
    }
    
    //context menu options for map when user long presses on map
    func makeContextMenu()-> UIMenu{
        let standard = UIAction(title: NSLocalizedString("std", comment: "std map"), image: nil){
            action in self.mapView.mapType = .standard
        }
        let satellite = UIAction(title: NSLocalizedString("stl", comment: "satellite map"), image: nil){
            action in self.mapView.mapType = .satellite
        }
        let hybrid = UIAction(title: NSLocalizedString("hyb", comment: "hybrid map"), image: nil){
            action in self.mapView.mapType = .hybrid
        }
        return UIMenu(title: NSLocalizedString("map_style", comment: "map"), children: [standard,satellite,hybrid])
    }
    

}


//to enable contex† menu
extension AddVacationVC : UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil,
        actionProvider: {suggestedActions in
        return self .makeContextMenu()
    }
        )
    }
    
    
}
