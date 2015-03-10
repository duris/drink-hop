//
//  PlaceSelectExtensions.swift
//  DrinkHop
//
//  Created by Ross Duris on 2/21/15.
//  Copyright (c) 2015 Pear Soda LLC. All rights reserved.
//

import UIKit
import Foundation
import UIKit

extension PlaceSelectViewController: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (self.placesSearchController.active)
        {
            return self.placesArray.count
        } else
        {
            return self.placesArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = self.placesTable.dequeueReusableCellWithIdentifier("Cell") as PlaceSelectTableViewCell
        var place = self.placesArray[indexPath.row] as GooglePlace
        var distance = self.placeDistances[indexPath.row] as String
        if (self.placesSearchController.active)
        {
            cell.placeNameLabel.text = place.name
            cell.addressNameLabel.text = place.address
            cell.distanceLabel.text = distance + " mi"
        }
        else
        {
            
            cell.placeNameLabel.text = place.name
            cell.addressNameLabel.text = place.address
            cell.distanceLabel.text = distance + " mi"
        }
        return cell
    }
}

extension PlaceSelectViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
}

extension PlaceSelectViewController: UISearchResultsUpdating
{
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        
        self.searchedKeyword = placesSearchController.searchBar.text
        self.fetchNearbyPlaces(self.coordinates)
        self.placesTable.reloadData()
    }
}
