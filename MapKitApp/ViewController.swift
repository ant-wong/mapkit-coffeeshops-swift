//
//  ViewController.swift
//  MapKitApp
//
//  Created by Anthony Wong on 2018-07-27.
//  Copyright © 2018 Anthony Wong. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    var venues = [Venue]()
    
    /* Fetchd data from JSON file, or this is where you fetch data from REST API */
    func fetchData() {
        let fileName = Bundle.main.path(forResource: "Venues", ofType: "json")
        let filePath = URL(fileURLWithPath: fileName!)
        var data: Data?
        do {
            data = try Data(contentsOf: filePath, options: Data.ReadingOptions(rawValue: 0))
        } catch let error {
            data = nil
            print("Report error \(error.localizedDescription)")
        }
        
        /* If there is data, fetch the specific key values you need from JSON object */
        if let jsonData = data {
            do {
                let json = try JSON(data: jsonData)
                if let venueJSONs = json["response"]["venues"].array {
                    for venueJSON in venueJSONs {
                        if let venue = Venue.from(json: venueJSON) {
                            self.venues.append(venue)
                        }
                    }
                }
            } catch let error {
                print("Report error \(error.localizedDescription)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* San Fran coords */
        let initialLocation = CLLocation(latitude: 37.7749, longitude: -122.431297)
        zoomMapOn(location: initialLocation)
        
        /* Create a sample pin on load */
        /*
            let sampleStarbucks = Venue(title: "Mock Starbucks", locationName: "Some street lolol", coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.431297))
            mapView.addAnnotation(sampleStarbucks)
        */
        
        mapView.delegate = self
        
        /* Call func to get JSON data and create multiple annotations */
        fetchData()
        mapView.addAnnotations(venues)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationServiceAuthenticationStatus()
    }
    
    /* Set radius of zoom on map load. */
    private let regionRadius: CLLocationDistance = 1000
    
    /* Helper function to set inital location */
    func zoomMapOn(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    /* Get current location of user. Check if authorization has been given, or ask for it. */
    var locationManager = CLLocationManager()
    
    func checkLocationServiceAuthenticationStatus() {
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        self.mapView.showsUserLocation = true
        zoomMapOn(location: location)
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
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Venue
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
