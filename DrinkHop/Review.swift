//
//  Review.swift
//  DrinkHop
//
//  Created by Ross Duris on 2/22/15.
//  Copyright (c) 2015 duris.io. All rights reserved.
//

import Foundation

class Review {
    var drinkName = ""
    var drinkDistance = 0.0
    var placeName = ""
    var location:PFGeoPoint = PFGeoPoint()
    var tempIndex:NSIndexPath
    var image:UIImage
    var user:PFUser
    
    init(drinkName:String, drinkDistance:Double, placeName:String, location:PFGeoPoint, tempIndex:NSIndexPath, image: UIImage, user: PFUser){
        self.drinkName = drinkName
        self.drinkDistance = drinkDistance
        self.placeName = placeName
        self.location = location
        self.tempIndex = tempIndex
        self.image = image
        self.user = user
    }
}