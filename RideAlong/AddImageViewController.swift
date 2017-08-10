//
//  AddImageViewController.swift
//  RideAlong
//
//  Created by Richard H on 03/08/2017.
//  Copyright © 2017 Richard H. All rights reserved.
//

import UIKit
import MapKit

class AddImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var coordinates: CLLocationCoordinate2D!
    
    var route: Route!
    
    var stack: CoreDataHandler! = nil

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.stack = appDelegate.stack
        
        
    }
    
    //Mark: Take a photo
    func takePhoto(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func photoAlbum(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }

    @IBAction func takePhoto(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Image", message:"", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let photoAction = UIAlertAction(title:"Take Photo", style: .default, handler: {_ in self.takePhoto()})
            alert.addAction(photoAction)
        }
        
        let albumAction = UIAlertAction(title: "Photo Album", style: .default, handler: {_ in self.photoAlbum()})
        alert.addAction(albumAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        self.present(alert, animated:true, completion:nil)
        
    }
    
    
    //Mark: add photo to imageview
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func saveImageButtonPressed(_ sender: Any) {
        
        if self.imageView.image != nil{
            
            if self.imageView.image != UIImage(named: "defaultImage"){
                
                let photo = Photo(latitude: self.coordinates.latitude, longitude: self.coordinates.longitude, context: self.stack.context)
                photo.image = UIImagePNGRepresentation(self.imageView.image!) as NSData?
                route.addToPhotos(photo)
                photo.route = route
                self.stack.save()
                self.navigationController?.popViewController(animated: true)
            }else{
                ErrorMessage.displayErrorMessage(message: "There is no image to save", view: self)
            }
            
        }else{
            ErrorMessage.displayErrorMessage(message: "There is no image to save", view: self)
        }
        
        
    }
}
