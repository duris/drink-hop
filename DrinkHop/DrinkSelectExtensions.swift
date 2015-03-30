//
//  DrinkSelectExtensions.swift
//  DrinkHop
//
//  Created by Ross Duris on 2/21/15.
//  Copyright (c) 2015 duris.io. All rights reserved.
//

import Foundation
import UIKit

extension DrinkSelectViewController: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (self.drinkSearchController.active)
        {
            if (self.drinkSearchController.searchBar.text != "" && self.filteredDrinksArray.count == 0){
                return 0
            }else {
            return self.filteredDrinksArray.count
            }
        } else
        {
            return self.filteredDrinksArray.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = self.drinkTable.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        if (self.drinkSearchController.active)
        {
            if  self.filteredDrinksArray.count == 0 {
//                delay(1){
//                    var searchTxt = self.drinkSearchController.searchBar.text
//                    println(searchTxt)
//                    cell.textLabel?.text! = "Can't find \(searchTxt)? Add to DrinkHop"
//
//                }
                //cell.textLabel?.text! = "No Results"
            } else {
                let drink:PFObject! = self.filteredDrinksArray[indexPath.row] as PFObject
                cell.textLabel?.text! = drink.objectForKey("name") as String!
            }
        }
        else
        {
            let drink:PFObject! = self.filteredDrinksArray[indexPath.row] as PFObject
            cell.textLabel?.text! = drink.objectForKey("name") as String!
        }
        return cell
    }
    
 
}

extension DrinkSelectViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
  
    }
}

extension DrinkSelectViewController: UISearchResultsUpdating
{
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        if self.drinksArray.count == 0 {
            self.loadFilteredDrinks(self.drinkSearchController.searchBar.text)
        }
    }
    
}