//
//  ImageCollectionViewController.swift
//  RideAlong
//
//  Created by Richard H on 03/08/2017.
//  Copyright © 2017 Richard H. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ImageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var photos: [PhotoItem]!
    
    var pageCount: Int!
    
    let connectionHandler = ConnectionHandler()
    
    var pageNum: Int = 2
    
    var photo: Photo!
    var route: Route!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! ImageCollectionViewCell
    
        // Configure the cell
        cell.activityView.startAnimating()
        cell.activityView.isHidden = false
        if cell.imageView.image != UIImage(named: "defaultString"){
            cell.imageView.image = UIImage(named: "defaultImage")
        }
        
        var urlString: String?
        
        if photos.indices.contains(indexPath.row){
            let photo = photos[indexPath.row]
            urlString = photo.url
        }
        cell.setCellImage(urlString: urlString!)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        let image = cell.imageView.image
        
        let locationPhotoViewController = self.storyboard?.instantiateViewController(withIdentifier: "LocationPhotoViewController") as! LocationPhotoViewController
        locationPhotoViewController.route = self.route
        locationPhotoViewController.image = image
        locationPhotoViewController.photo = self.photo

        self.navigationController?.pushViewController(locationPhotoViewController, animated: true)
        
        
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == photos.count - 4{
            
            let latitude = self.photo.latitude
            let longitude = self.photo.longitude
            
            self.connectionHandler.fetchImagesForLocation(longitude: String(longitude), latitude: String(latitude), pageNumber: pageNum, completionHandler: { (results, error) in
                
                if error == nil{
                    
                    let photoCollection = results?["photos"] as! [AnyObject]
                    
                    if photoCollection.count > 0{
                        
                        for photo in photoCollection{
                            
                            let photo = PhotoItem(url: photo["url_m"] as? String)
                            self.photos.append(photo)
                            
                        }
                        
                        DispatchQueue.main.async {
                            self.collectionView?.performBatchUpdates({
                                let indexSet = IndexSet(integer: 0)
                                self.collectionView?.reloadSections(indexSet)
                            }, completion: nil)
                        }
                        
                    }
                    
                    
                    
                }
                
            })
            pageNum += 1
            
        }
        
    }
    
    
    //Mark: set the size of the cells depending on the width of the screen plus the margins
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let dimension = (self.view.frame.size.width - 6.0) / 3.0
        return CGSize(width: dimension, height: dimension)
    }
    
    //Mark: return minimum line spacing - called when layout is invalidated
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(3.0)
    }
    
    //Mark: return minimum interim spacing - called when layout is invalidated
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(3.0)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.flowLayout.invalidateLayout()
    }

}
