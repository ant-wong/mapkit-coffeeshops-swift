//
//  Venue.swift
//  MapKitApp
//
//  Created by Anthony Wong on 2018-07-28.
//  Copyright © 2018 Anthony Wong. All rights reserved.
//

import MapKit
import AddressBook

/* Class for venues/pins */
class Venue: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    /* MKAnnotation */
    var subtitle: String? {
        return locationName
    }
}
