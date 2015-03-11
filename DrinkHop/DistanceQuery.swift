//
//  DistanceQuery.swift
//  DrinkHop
//
//  Created by Ross Duris on 2/22/15.
//  Copyright (c) 2015 Pear Soda LLC. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class DistanceQuery {
    
    let duration: String
    let distance: String

    
    init(dictionary:NSDictionary)
    {
        duration = dictionary["name"] as String
        distance = dictionary["vicinity"] as String

    }
}
