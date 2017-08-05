//
//  ViewRouteViewController.swift
//  RideAlong
//
//  Created by Richard H on 03/08/2017.
//  Copyright © 2017 Richard H. All rights reserved.
//

import UIKit
import MapKit

class ViewRouteViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var route: Route!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self

        // Do any additional setup after loading the view.
        
        let locationPoints = self.route.points as! [CLLocation]
        print(locationPoints.count)
        if locationPoints.count > 1{
            //let sourceIndex = locationPoints.count - 1
            //let destinationIndex = locationPoints.count - 2
            //let c1 = locationPoints[sourceIndex].coordinate
            //let c2 = locationPoints[destinationIndex].coordinate
            //var array = [c1, c2]
            
            
            var coordinates = locationPoints.map({ (location: CLLocation!) -> CLLocationCoordinate2D in
                return location.coordinate
            })
            
            print(coordinates)
            
            let polyline = MKPolyline(coordinates: &coordinates, count: locationPoints.count)
            self.mapView.add(polyline, level: MKOverlayLevel.aboveRoads)
            
            
            let spanX = 0.007
            let spanY = 0.007
            let region = MKCoordinateRegion(center: locationPoints[0].coordinate, span: MKCoordinateSpanMake(spanX, spanY))
            self.mapView.setRegion(region, animated: true)
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

}
