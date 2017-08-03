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
    
    @IBOutlet weak var startRouteButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    
    var locationManager:CLLocationManager!
    var locationPoints: [CLLocation] = []
    
    var recordingLocations: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationPoints.append(locations[0] as CLLocation)
        recordingLocations = true
        
        let spanX = 0.007
        let spanY = 0.007
        let region = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        self.mapView.setRegion(region, animated: true)
        
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
        }else{
            print("Starting route")
            self.mapView.showsUserLocation = true
            self.locationManager.startUpdatingLocation()
            self.startRouteButton.setTitle("Stop Route", for: .normal)
        }
        
        
    }

    //Mark: add an image to the route
    @IBAction func addImage(_ sender: Any) {
    }
}
