//
//  MainRouteControllerViewController.swift
//  RideAlong
//
//  Created by Richard H on 01/08/2017.
//  Copyright © 2017 Richard H. All rights reserved.
//

import UIKit
import MapKit

class MainRouteControllerViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

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
    
    //Mark: Custom navigation controller back button
    func backButtonAction(sender: UIBarButtonItem){
        if recordingLocations{
            print("Stopping route")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //Mark: start the route recording
    @IBAction func startRoute(_ sender: Any) {
        
        if recordingLocations{
            print("Stopping route")
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
                print("Starting route")
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
