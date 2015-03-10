//
//  GooglePlace.swift
//  DrinkHop
//
//  Created by Ross Duris on 2/20/15.
//  Copyright (c) 2015 Pear Soda LLC. All rights reserved.
//

//
//  GooglePlace.swift
//  Feed Me
//
//  Created by Ron Kliffer on 8/30/14.
//  Copyright (c) 2014 Ron Kliffer. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class GooglePlace {
    
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let placeType: String
    let photoReference: String?
    var photo: UIImage?
    var placeId: String
    
    init(dictionary:NSDictionary, acceptedTypes: [String])
    {
        name = dictionary["name"] as String
        address = dictionary["vicinity"] as String
        placeId = dictionary["place_id"] as String
        
        let location = dictionary["geometry"]?["location"] as NSDictionary
        let lat = location["lat"] as CLLocationDegrees
        let lng = location["lng"] as CLLocationDegrees
        coordinate = CLLocationCoordinate2DMake(lat, lng)
        
        if let photos = dictionary["photos"] as? NSArray {
            let photo = photos.firstObject as NSDictionary
            photoReference = photo["photo_reference"] as? NSString
        }
        
        var foundType = "restaurant"
        let possibleTypes = acceptedTypes.count > 0 ? acceptedTypes : ["bar"]
        for type in dictionary["types"] as [String] {
            if contains(possibleTypes, type) {
                foundType = type
                break
            }
        }
        placeType = foundType
    }
}

