//
//  MainExtensions.swift
//  DrinkHop
//
//  Created by Ross Duris on 2/22/15.
//  Copyright (c) 2015 Pear Soda LLC. All rights reserved.
//

import Foundation
import UIKit

extension MainViewController: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (self.mainSearchController.active)
        {
            if (self.mainSearchController.searchBar.text != "" && self.drinksArray.count == 0){
                return 1
            }else {
                return self.drinksArray.count
            }
        } else
        {
            return self.drinksArray.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = self.drinkTable.dequeueReusableCellWithIdentifier("Cell") as MainTableViewCell
        
        self.drinksArray.sort({$0.drinkDistance < $1.drinkDistance})
        if (self.mainSearchController.active)
        {
            let drink:Review = drinksArray[indexPath.row]
            let miles = String(format:"%.0f", drink.drinkDistance)
            cell.drinkNameLabel.text! = drink.drinkName
            cell.distanceLabel.text! = miles + " mi"
            cell.placeNameLabel.text! = "At " + drink.placeName
        }
        else
        {
            let drink:Review = drinksArray[indexPath.row]
            let miles = String(format:"%.0f", drink.drinkDistance)
            cell.drinkNameLabel.text! = drink.drinkName
            cell.distanceLabel.text! = miles + " mi"
            cell.placeNameLabel.text! = "At " + drink.placeName
        }
        return cell
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
}

extension MainViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
}

extension MainViewController: UISearchResultsUpdating
{
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {

    }
    
}
