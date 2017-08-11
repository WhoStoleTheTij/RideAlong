//
//  MainRouteControllerViewController.swift
//  RideAlong
//
//  Created by Richard H on 01/08/2017.
//  Copyright © 2017 Richard H. All rights reserved.
//

import UIKit
import MapKit

class MainRouteControllerViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var startRouteButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    
    var locationManager:CLLocationManager!
    var locationPoints: [CLLocation] = []
    
    var recordingLocations: Bool = false
    
    var stack: CoreDataHandler! = nil
    
    var route: Route! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.nameTextfield.delegate = self
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.stack = appDelegate.stack
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target:self, action:#selector(MainRouteControllerViewController.backButtonAction(sender:)) )
        self.navigationItem.leftBarButtonItem = newBackButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.unsubscribeToKeyboardNoticifations()
    }
    
    //Mar: setup the keyboard hide/show subscriptions
    func subscribeToKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(MainRouteControllerViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainRouteControllerViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object:nil)
    }
    
    //Mark: called when the keyboard shows
    func keyboardWillShow(notification: NSNotification){
        self.view.frame.origin.y = -getKeyboardHeight(notification: notification)
    }
    
    //Mark: get the height of the keyboard - will return zero if the activeTextfield is not the bottom textfield
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    //Mark: called when the keyboard hides
    func keyboardWillHide(notification: NSNotification){
        self.view.frame.origin.y = 0
    }
    
    //Mark: remove the keyboard hide/show subscriptions
    func unsubscribeToKeyboardNoticifations(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object:nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object:nil)
    }
    
    //Mark: dismiss the keyboard when the enter key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Mark: Custom navigation controller back button
    func backButtonAction(sender: UIBarButtonItem){
        if recordingLocations{
            
            self.locationManager.stopUpdatingLocation()
            self.startRouteButton.setTitle("Start Route", for: .normal)
            self.addImageButton.isEnabled = false
            self.mapView.removeOverlays(self.mapView.overlays)
        }
        self.navigationController?.popViewController(animated: true)
    }

    //Mark: update the route points
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationPoints.append(locations[0] as CLLocation)
        recordingLocations = true
        
        let spanX = 0.007
        let spanY = 0.007
        let region = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        self.mapView.setRegion(region, animated: true)
        
        if locationPoints.count > 1 {
            let sourceIndex = locationPoints.count - 1
            let destinationIndex = locationPoints.count - 2
            let c1 = locationPoints[sourceIndex].coordinate
            let c2 = locationPoints[destinationIndex].coordinate
            var array = [c1, c2]
            let polyline = MKPolyline(coordinates: &array, count: array.count)
            self.mapView.add(polyline)
        }
    }
    
    
    //Mark: draw the route on the map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay:overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        
        return MKPolylineRenderer()
    }
    
    //Mark: start the route recording
    @IBAction func startRoute(_ sender: Any) {
        
        if recordingLocations{
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
            self.navigationController?.navigationBar.tintColor = UIColor.blue
            self.locationManager.stopUpdatingLocation()
            self.startRouteButton.setTitle("Start Route", for: .normal)
            self.addImageButton.isEnabled = false
            self.route.points = self.locationPoints as NSArray
            self.stack.save()
            self.navigationController?.popViewController(animated: true)
        }else{
            
            if (self.nameTextfield.text?.isEmpty)!{
                ErrorMessage.displayErrorMessage(message: "Please enter a name first", view: self)
            }else{
                self.navigationController?.navigationBar.isUserInteractionEnabled = false
                self.navigationController?.navigationBar.tintColor = UIColor.lightGray
                self.route = Route(name: self.nameTextfield.text!, context: self.stack.context)
                self.stack.save()
                self.addImageButton.isEnabled = true
                self.mapView.showsUserLocation = true
                self.locationManager.startUpdatingLocation()
                self.startRouteButton.setTitle("Stop Route", for: .normal)
            }
            
        }
        
        
    }

    //Mark: add an image to the route
    @IBAction func addImage(_ sender: Any) {
        
        let coordinates = self.mapView.userLocation.coordinate
        
        let addImageViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddImageViewController") as! AddImageViewController
        addImageViewController.route = self.route!
        addImageViewController.coordinates = coordinates
        self.navigationController?.pushViewController(addImageViewController, animated: true)
        
        
    }
}
