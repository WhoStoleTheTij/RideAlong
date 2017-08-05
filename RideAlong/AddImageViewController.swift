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
    
    //Mark: Take a photo
    func takePhoto(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        self.present(pickerController, animated: true, completion: nil)
    }

    @IBAction func takePhoto(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            self.takePhoto()
        }else{
            ErrorMessage.displayErrorMessage(message: "This device is not able to take photos", view: self)
        }
        
        
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
                route.addToPhotos(photo)
                photo.route = route
                
            }else{
                ErrorMessage.displayErrorMessage(message: "There is no image to save", view: self)
            }
            
        }else{
            ErrorMessage.displayErrorMessage(message: "There is no image to save", view: self)
        }
        
        
    }
}
