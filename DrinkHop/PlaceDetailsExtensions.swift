//
//  PlaceDetailsExtensions.swift
//  DrinkHop
//
//  Created by Ross Duris on 2/21/15.
//  Copyright (c) 2015 Pear Soda LLC. All rights reserved.
//

import UIKit

import Foundation
import UIKit

extension PlaceDetailsViewController: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (self.drinkSearchController.active)
        {
            return self.filteredDrinksArray.count
        } else
        {
            return self.filteredDrinksArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = self.drinkTable.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        let drink:PFObject! = self.filteredDrinksArray[indexPath.row] as PFObject
        
        if (self.drinkSearchController.active)
        {
            cell.textLabel?.text! = drink.objectForKey("name") as String!
        }
        else
        {
            
            cell.textLabel?.text! = drink.objectForKey("name") as String!
        }
        return cell
    }
}

extension PlaceDetailsViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
}

extension PlaceDetailsViewController: UISearchResultsUpdating
{
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        if self.drinkSearchController.searchBar.text != nil {
            self.loadFilteredDrinks(self.drinkSearchController.searchBar.text)
            self.drinkTable.reloadData()
            }
        self.drinkTable.reloadData()
    }
    
}
