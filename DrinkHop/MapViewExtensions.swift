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
        if (self.mapSearchController.active)
        {
            return 1
        } else
        {
            return 1
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = self.locationTable.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        cell.textLabel?.text = "hello"
   
        return cell
    }    

}

extension MapViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.locationTable.hidden = true
    }
}

extension MapViewController: UISearchResultsUpdating
{
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        if (self.mapSearchController.active) {
            self.locationTable.hidden = false
        }
    }
    
}
