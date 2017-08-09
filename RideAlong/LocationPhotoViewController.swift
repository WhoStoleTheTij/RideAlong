//
//  LocationPhotoViewController.swift
//  RideAlong
//
//  Created by Richard H on 09/08/2017.
//  Copyright © 2017 Richard H. All rights reserved.
//

import UIKit

class LocationPhotoViewController: UIViewController {

    var route: Route!
    var photo: Photo!
    
    var image: UIImage!
    
    var stack: CoreDataHandler! = nil
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = self.image
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.stack = appDelegate.stack

        // Do any additional setup after loading the view.
    }

    //Mark: save photo from flickr collection to route location
    @IBAction func savePhotoToRoute(_ sender: Any) {
        
        let savePhoto = Photo(latitude: self.photo.latitude, longitude: self.photo.longitude, context: self.stack.context)
        savePhoto.image = UIImagePNGRepresentation(self.image)! as NSData
        route.addToPhotos(savePhoto)
        
        self.stack.save()
        self.navigationController?.popViewController(animated: true)
        
    }

    
}
