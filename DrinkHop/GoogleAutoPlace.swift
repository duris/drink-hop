//
//  GoogleAutoPlace.swift
//  DrinkHop
//
//  Created by Ross Duris on 3/12/15.
//  Copyright (c) 2015 Pear Soda LLC. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class GoogleAutoPlace {
    
    let description: String

    init(dictionary:NSDictionary)
    {
        description = dictionary["description"] as String
    }
}
