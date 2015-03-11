//
//  PlaceSearchExtensions.swift
//  DrinkHop
//
//  Created by Ross Duris on 2/20/15.
//  Copyright (c) 2015 Pear Soda LLC. All rights reserved.
//

import UIKit

import Foundation
import UIKit

extension PlaceSearchViewController: UITableViewDataSource
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
        var cell = self.placesTable.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        var place = self.placesArray[indexPath.row] as GooglePlace
        
        if (self.placesSearchController.active)
        {
            let place = self.placesArray[indexPath.row] as GooglePlace
            cell.textLabel?.text! = place.name
        }
        else
        {
            
            cell.textLabel?.text! = place.name
        }
        return cell
    }
}

extension PlaceSearchViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
}

extension PlaceSearchViewController: UISearchResultsUpdating
{
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.searchedKeyword = searchController.searchBar.text        
    }
}