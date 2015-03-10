//
//  PlaceMarker.swift
//  DrinkHop
//
//  Created by Ross Duris on 2/23/15.
//  Copyright (c) 2015 Pear Soda LLC. All rights reserved.
//

import Foundation

class PlaceMarker: GMSMarker {
    // 1
    let review: Review
    
    // 2
    init(review: Review) {
        self.review = review
        super.init()
        
        position = review.location.coordinate
        //icon = UIImage(named: place.placeType+"_pin")
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = kGMSMarkerAnimationPop
    }
}
