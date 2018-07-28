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
    }
    
    /* Set radius of zoom on map load. */
    private let regionRadius: CLLocationDistance = 1000
    /* Helper function to set inital location */
    func zoomMapOn(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
