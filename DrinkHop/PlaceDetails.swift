//
//  PlaceDetails.swift
//  DrinkHop
//
//  Created by Ross Duris on 3/12/15.
//  Copyright (c) 2015 Pear Soda LLC. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class PlaceDetails {
    
    let coordinate: CLLocationCoordinate2D
    
    init(dictionary:NSDictionary)
    {
        let location = dictionary["geometry"]?["location"] as NSDictionary
        let lat = location["lat"] as CLLocationDegrees
        let lng = location["lng"] as CLLocationDegrees
        coordinate = CLLocationCoordinate2DMake(lat, lng)        
    }
}