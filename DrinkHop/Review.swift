//
//  Review.swift
//  DrinkHop
//
//  Created by Ross Duris on 2/22/15.
//  Copyright (c) 2015 Pear Soda LLC. All rights reserved.
//

import Foundation

class Review {
    var drinkName = ""
    var drinkDistance = 0.0
    var placeName = ""
    var location:CLLocation = CLLocation()
    var tempIndex:NSIndexPath
    var id:String
    
    init(drinkName:String, drinkDistance:Double, placeName:String, reviewLocation:CLLocation, tempIndex:NSIndexPath, id: String){
        self.drinkName = drinkName
        self.drinkDistance = drinkDistance
        self.placeName = placeName
        self.location = reviewLocation
        self.tempIndex = tempIndex
        self.id = id
    }
}