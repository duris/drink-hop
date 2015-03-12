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
            return 1
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
        //self.locationTable.hidden = true
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
                }
                self.locationTable.reloadData()
                self.mapSearchController.searchDisplayController?.searchResultsTableView.reloadData()
        }
        
    }
  }
}
