//
//  DetailedVacationVC.swift
//  FinalCapstoneGroup6
//
//  Created by user213797 on 12/6/22.
//


import UIKit

class DetailedVacationVC: UIViewController {
    
    
    @IBOutlet weak var vacationLoc: UILabel!
    var images = [Image]()
    let imageList : ImageList = ImageList()
    
    @IBOutlet weak var NumberOfPeople: UILabel!
    
    @IBOutlet weak var vacationNote: UILabel!
    @IBOutlet weak var VacationPictures: UICollectionView!
    
    @IBOutlet weak var error: UILabel!
    
    //open maps in maps application
    @IBAction func openMaps(_ sender: Any) {
        if vacation.lat != 0 , vacation.lng != 0 {
        guard let url = URL(string:"http://maps.apple.com/?ll=\(vacation.lat),\(vacation.lng)") else { return }
           UIApplication.shared.open(url)
        } else {
            error.text = NSLocalizedString("error_warning", comment: "err str")
        }
        
    }
    var vacation : TripPlan!
    override func viewDidLoad() {
        super.viewDidLoad()
        //displaying data recieved from segue
        imageList.setLocation(location: vacation.location!) //setting location to imageList object to fetch images from API call
        vacationLoc.text = "\(NSLocalizedString("location", comment: "loc str"))\(vacation.location! )"
        vacationNote.text = "\(NSLocalizedString("note", comment: "note"))\(vacation.note!)"
        NumberOfPeople.text = "\(NSLocalizedString("num", comment: "numOfPeople"))\(vacation.numnberOfPeople)"
       
        //fetching json response from api call and adding results in images array.
        imageList.getJSONResponseOfImages{(photosResult)->Void in
            switch photosResult {
                case let .success(images):
                    self.images = images
                    self.VacationPictures.reloadData()
                case let .failure(error):
                    self.error.text = "\(error)" //displaying error
            }
            }
    }
    
    
    

}

extension DetailedVacationVC : UICollectionViewDataSource, UICollectionViewDelegate {
    //delegate
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            let imgIndex = indexPath.item
            let image = images[imgIndex]
            //fetching image from URL
            imageList.fetchImage(for: image) { (result)->Void in
                guard let photoIndex = self.images.firstIndex(of: image),
                    case let .success(image) = result
                    else {
                        return
                    }
                let photoIndexPath = IndexPath(item: photoIndex, section: 0)
                if let ImgCell = self.VacationPictures.cellForItem(at: photoIndexPath) as?
                            ImageViewCell {
                    //stops activity loader from spinning
                    ImgCell.startStopLoader(with: image)
                }
            }
    }

    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        configureContextMenu(index: indexPath.row) //addind context menu to collection item
    }

    //configuraing context menu in function
    func configureContextMenu(index: Int) -> UIContextMenuConfiguration {
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            //adding two options to open
            let edit = UIAction(title: NSLocalizedString("open_browser", comment: ""), image: UIImage(systemName: "globe"), identifier: nil, discoverabilityTitle: nil, state: .off) { (_) in
                print("edit button clicked")
                guard let url = URL(string:"\(self.images[index].download_url)") else { return }
                   UIApplication.shared.open(url)
            }
            //addind delete to remove image from collection view
            let delete = UIAction(title: "\(NSLocalizedString("Delete", comment: "delete str"))", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil,attributes: .destructive, state: .off) { (_) in
                self.images.remove(at: index)
                self.VacationPictures.reloadData();
            }
            
            return UIMenu(title: NSLocalizedString("options", comment: "opt"), image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [edit,delete])
            
        }
        return context
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "ImageViewCell"
        let ImgCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ImageViewCell
         return ImgCell
    }
}

    
    
    
