//
//  PlaceDetailsViewController.swift
//  DrinkHop
//
//  Created by Ross Duris on 2/21/15.
//  Copyright (c) 2015 Pear Soda LLC. All rights reserved.
//

import UIKit

class PlaceDetailsViewController: UIViewController {
    
    @IBOutlet weak var drinkTable:UITableView!
    var drinkSearchController = UISearchController()
    var drinksArray:NSMutableArray = NSMutableArray()
    var filteredDrinksArray:NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.drinkTable.delegate = self
        self.drinkTable.dataSource = self
        
        loadFilteredDrinks("")
        
        self.drinkSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "What drink did you get?"
            //controller.searchBar.text = ""
            controller.searchBar.autocorrectionType = UITextAutocorrectionType.Yes
            //controller.searchBar.delegate = self
            self.drinkTable.tableHeaderView = controller.searchBar
            return controller
        })()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadFilteredDrinks(searchText:String){
        filteredDrinksArray.removeAllObjects()
        var query : PFQuery = PFQuery(className: "Drink")
        query.whereKey("name", containsString: searchText)
        query.limit = 50
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects{
                    let drink:PFObject! = object as PFObject
                    println(drink.objectForKey("name"))
                    self.filteredDrinksArray.addObject(drink as PFObject)
                }
            } else {
                println("no drinks")
            }
            self.drinkTable.reloadData()
            self.searchDisplayController?.searchResultsTableView.reloadData()
        }
    }
    
    

}
