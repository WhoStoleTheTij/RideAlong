//
//  PhotoViewController.swift
//  RideAlong
//
//  Created by Richard H on 03/08/2017.
//  Copyright © 2017 Richard H. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    var photo: Photo!
    
    var connectionHandler = ConnectionHandler()

    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if photo != nil && photo.image != nil{
            self.imageView.image = UIImage(data: photo.image! as Data)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //Mark: load photos from flickr for the same location as the user photo
    @IBAction func loadMorePhotos(_ sender: Any) {
        
        let latitude = self.photo.latitude
        let longitude = self.photo.longitude
        
        self.connectionHandler.fetchImagesForLocation(longitude: String(longitude), latitude: String(latitude), pageNumber: 1) { (results, error) in
            
            if error == nil{
                
            }else{
                ErrorMessage.displayErrorMessage(message: error!, view: self)
            }
            
            
        }
        
    }
}
