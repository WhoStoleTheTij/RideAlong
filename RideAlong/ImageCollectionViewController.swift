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
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        var urlString: String?
        
        if photos.indices.contains(indexPath.row){
            let photo = photos[indexPath.row]
            urlString = photo.url
        }
        cell.setCellImage(urlString: urlString!)
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //infinite scroll
        /*
         If indexPath.row == photos.count - 1 (or whatever)
         load images if the scroll direction is down
         
         */
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

}
