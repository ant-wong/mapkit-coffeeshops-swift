//
//  ViewController.swift
//  MapKitApp
//
//  Created by Anthony Wong on 2018-07-27.
//  Copyright © 2018 Anthony Wong. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* San Fran coords */
        let initialLocation = CLLocation(latitude: 37.7749, longitude: -122.431297)
        zoomMapOn(location: initialLocation)
        
        /* Create a sample pin on load */
        let sampleStarbucks = Venue(title: "Mock Starbucks", locationName: "Some street lolol", coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.431297))
        mapView.addAnnotation(sampleStarbucks)
        mapView.delegate = self
    }
    
    /* Set radius of zoom on map load. */
    private let regionRadius: CLLocationDistance = 1000
    
    /* Helper function to set inital location */
    func zoomMapOn(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        /* Check if pin has annotation, if not create one for it */
        if let annotation = annotation as? Venue {
            let indentifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: indentifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: indentifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
}
