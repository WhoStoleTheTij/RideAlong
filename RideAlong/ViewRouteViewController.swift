//
//  ViewRouteViewController.swift
//  RideAlong
//
//  Created by Richard H on 03/08/2017.
//  Copyright © 2017 Richard H. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ViewRouteViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var route: Route!
    
    var stack: CoreDataHandler! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.stack = appDelegate.stack

        // Do any additional setup after loading the view.
        
        let locationPoints = self.route.points as! [CLLocation]
        print(locationPoints.count)
        if locationPoints.count > 1{
            
            var coordinates = locationPoints.map({ (location: CLLocation!) -> CLLocationCoordinate2D in
                return location.coordinate
            })
            
            let polyline = MKPolyline(coordinates: &coordinates, count: locationPoints.count)
            self.mapView.add(polyline)
            
            //if the route has photos, add a pin at the location it was taken
            if (self.route.photos?.count)! > 0{
                var annotations = [MKPointAnnotation]()
                let photos = self.route.photos?.allObjects as! [Photo]

                for photo in photos{
                    
                    let lat = CLLocationDegrees(photo.latitude)
                    let long = CLLocationDegrees(photo.longitude)
                    
                    let coord = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coord
                    
                    annotations.append(annotation)
                }
                
                self.mapView.addAnnotations(annotations)
                
                
                
                
            }else{
                //let spanX = 0.007
                //let spanY = 0.007
                //let region = MKCoordinateRegion(center: locationPoints[0].coordinate, span: MKCoordinateSpanMake(spanX, spanY))
                //self.mapView.setRegion(region, animated: true)
            }
            
            let startCood = locationPoints[0]
            let endCoord = locationPoints[locationPoints.count - 1]
            
            let startAnnotation = MKPointAnnotation()
            startAnnotation.coordinate = startCood.coordinate
            
            let endAnnotation = MKPointAnnotation()
            endAnnotation.coordinate = endCoord.coordinate
            
            self.mapView.showAnnotations([startAnnotation, endAnnotation], animated: true)
            //remove the first and last pin as they are not linked to photos
            self.mapView.removeAnnotations([startAnnotation, endAnnotation])
            
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
    
    //Mark: display the user photo for the selected pin
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let point = view.annotation as! MKPointAnnotation
        
        let photo = self.locatePhoto(latitude: point.coordinate.latitude, longitude: point.coordinate.longitude)
        
        if photo != nil && photo?.image != nil{
            self.mapView.deselectAnnotation(point, animated: true)
            
            let routePhotoCollectionView = self.storyboard?.instantiateViewController(withIdentifier: "RoutePhotoCollectionViewController") as! RoutePhotoCollectionViewController
            routePhotoCollectionView.route = self.route
            
            self.navigationController?.pushViewController(routePhotoCollectionView, animated: true)
            
            
        }else{
            ErrorMessage.displayErrorMessage(message: "Oops! No image was found for that location", view: self)
        }
        
    }

    
    //Mark: find and return a photo
    func locatePhoto(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> Photo?{
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        
        let latPredicate = NSPredicate(format: "latitude == %@", argumentArray: [latitude])
        let longPredicate = NSPredicate(format: "longitude == %@", argumentArray: [longitude])
        let routePredicate = NSPredicate(format: "route == %@", argumentArray: [self.route])
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [latPredicate, longPredicate, routePredicate])
        
        fetchRequest.predicate = predicate
        
        if let photos = try? self.stack.context.fetch(fetchRequest) as? [Photo]{
            let photo: Photo
            if(photos?.count)! > 0{
                photo = (photos?[0])!
                return photo
            }
        }
        
        return nil
        
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
