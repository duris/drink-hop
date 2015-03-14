//
//  MapViewExtensions.swift
//  DrinkHop
//
//  Created by Ross Duris on 3/4/15.
//  Copyright (c) 2015 Pear Soda LLC. All rights reserved.
//

import Foundation
import UIKit

extension MapViewController: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if (self.mapSearchController.active) {
            return autoPlacesArray.count
        }else{
            return 0
        }
        
       
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = self.locationTable.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        
        if (self.mapSearchController.active) {
            cell.textLabel?.text = self.autoPlacesArray[indexPath.row].description
        }else{
          
        }
       
        return cell
    }    

}

extension MapViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        let place_id = self.autoPlacesArray[indexPath.row].place_id
        let placeName = self.autoPlacesArray[indexPath.row].description
        self.dataProvider.fetchPlaceDetails(place_id){
            places in

            for object in places {
                let place:PlaceDetails! = object as PlaceDetails
                self.mapSearchController.searchBar.resignFirstResponder()
                self.mapView.camera = GMSCameraPosition(target: object.coordinate, zoom: 12, bearing: 0, viewingAngle: 0)
                self.loadDrinks(object.coordinate)
                self.mapSearchController.searchBar.text = ""
                self.mapSearchController.searchBar.placeholder = placeName
                self.locationTable.hidden = true
                self.mapSearchController.searchBar.showsCancelButton = false

            }
        }
    }
}

extension MapViewController: UISearchResultsUpdating
{
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        if (self.mapSearchController.active) {
            self.autoPlacesArray.removeAll(keepCapacity: false)
            println("active")
            self.locationTable.hidden = false
            let searchText = self.mapSearchController.searchBar.text
            self.dataProvider.fetchAutoPlaces(searchText){
                places in
                
                for object: AnyObject in places {
                    let place:GoogleAutoPlace! = object as GoogleAutoPlace
                    self.autoPlacesArray.append(place)
                    println(place.description)
                    println(place.place_id)
                }
                self.locationTable.reloadData()
                self.mapSearchController.searchDisplayController?.searchResultsTableView.reloadData()
        }
        
    }
  }
}
