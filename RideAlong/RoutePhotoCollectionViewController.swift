//
//  RoutePhotoCollectionViewController.swift
//  RideAlong
//
//  Created by Richard H on 09/08/2017.
//  Copyright © 2017 Richard H. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class RoutePhotoCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var route: Route!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.route.photos!.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
    
        let photo = self.route.photos?.allObjects[indexPath.row] as! Photo
        
        cell.imageView.image = UIImage(data: photo.image! as Data)
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photo = self.route.photos?.allObjects[indexPath.row]
        
        let photoViewController = self.storyboard?.instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
        photoViewController.route = self.route
        photoViewController.photoPhoto = photo as! Photo
        
        self.collectionView?.deselectItem(at: indexPath, animated: true)
        self.navigationController?.pushViewController(photoViewController, animated: true)
        
        
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
