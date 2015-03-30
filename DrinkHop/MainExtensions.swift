//
//  MainExtensions.swift
//  DrinkHop
//
//  Created by Ross Duris on 2/22/15.
//  Copyright (c) 2015 duris.io. All rights reserved.
//

import Foundation
import UIKit

extension MainViewController: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if (self.mainSearchController.active)
        {
            if (self.mainSearchController.searchBar.text != "" && self.filteredReviewsArray.count == 0){
                return 0
            }else {
                return self.filteredReviewsArray.count
            }
        } else
        {
            return self.drinksArray.count
        }
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = self.drinkTable.dequeueReusableCellWithIdentifier("Cell") as MainTableViewCell
        
        
        if (self.mainSearchController.active)
        {
            if (self.mainSearchController.searchBar.text != "" && self.filteredReviewsArray.count == 0){
                println("no results")
            }else {
                self.filteredReviewsArray.sort({$0.drinkDistance < $1.drinkDistance})
                if self.filteredReviewsArray.count != 0 {
                    let drink:Review = filteredReviewsArray[indexPath.row]
                    let miles = String(format:"%.0f", drink.drinkDistance)
                    cell.drinkNameLabel.text! = drink.drinkName
                    cell.distanceLabel.text! = miles + " mi"
                    cell.placeNameLabel.text! = "At " + drink.placeName
                    cell.drinkImageView.image = drink.image
                    //cell.drinkImageView.frame.size.width/2
                    cell.drinkImageView.layer.cornerRadius =  10
                    cell.drinkImageView.clipsToBounds = true
                }else {
                    println("no data")
                }

            }
        } else
        {
            self.drinksArray.sort({$0.drinkDistance < $1.drinkDistance})
            if self.drinksArray.count != 0 {
                let drink:Review = drinksArray[indexPath.row]
                let miles = String(format:"%.0f", drink.drinkDistance)
                cell.drinkNameLabel.text! = drink.drinkName
                cell.distanceLabel.text! = miles + " mi"
                cell.placeNameLabel.text! = "At " + drink.placeName
                cell.drinkImageView.image = drink.image
                //cell.drinkImageView.frame.size.width/2
                cell.drinkImageView.layer.cornerRadius =  10
                cell.drinkImageView.clipsToBounds = true
            }else {
                println("no data")
            }

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

        //let length = self.mainSearchController.searchBar.text.utf16Count
        //println(length)
        
        
    }
    
}
