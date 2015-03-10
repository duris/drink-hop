//
//  GoogleDataProvider.swift
//  DrinkHop
//
//  Created by Ross Duris on 2/20/15.
//  Copyright (c) 2015 Pear Soda LLC. All rights reserved.
//

//
//  GoogleDataProvider.swift
//  Feed Me
//
//  Created by Ron Kliffer on 8/30/14.
//  Copyright (c) 2014 Ron Kliffer. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

var page_token:String = ""

class GoogleDataProvider {
    
    let apiKey = "AIzaSyBKvacsILX1FNuvXL4oMioe2fx08rtQM2k"
    var photoCache = [String:UIImage]()
    var placesTask = NSURLSessionDataTask()
    var session: NSURLSession {
        return NSURLSession.sharedSession()
    }
    let blockedPlaced = ["The Hornet's Nest", "McDonald's","Subway" ,"Wendy's", "KFC","Taco Bell","Tim Hortons", "Thurman To Go", "Domino's Pizza"]
    var seePlacesArray = [GooglePlace]()

    
    func fetchPlacesNearCoordinate(coordinate: CLLocationCoordinate2D, types:[String], keyword:String, completion: (([GooglePlace]) -> Void)) -> ()
    {
        var pageToken = ""
        var urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=\(apiKey)&location=\(coordinate.latitude),\(coordinate.longitude)&keyword=\(keyword)&radius=50000"
        let typesString = types.count > 0 ? join("|", types) : "nightclub"
        urlString += "&types=\(typesString)"
        urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        if placesTask.taskIdentifier > 0 && placesTask.state == .Running {
            placesTask.cancel()
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        placesTask = session.dataTaskWithURL(NSURL(string: urlString)!) {data, response, error in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            var placesArray = [GooglePlace]()
            if let json = NSJSONSerialization.JSONObjectWithData(data, options:nil, error:nil) as? NSDictionary {
                if let results = json["results"] as? NSArray {
                    for rawPlace:AnyObject in results {
                        let place = GooglePlace(dictionary: rawPlace as NSDictionary, acceptedTypes: types)

                        if contains(self.blockedPlaced, place.name) != true {
                            placesArray.append(place)
                            self.seePlacesArray.append(place)
                            println(place.name)
                        }
                        
                        if let reference = place.photoReference {
//                            self.fetchPhotoFromReference(reference) { image in
//                                place.photo = image
//                            }
                        }
                    }
                }
          
                if let next_page_token = json["next_page_token"] as? String {
                    page_token = next_page_token
                }

            }
            dispatch_async(dispatch_get_main_queue()) {
                completion(placesArray)
            }
        }
        placesTask.resume()
    }

    
    
    
    
    
    
    
    
}

