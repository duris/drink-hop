//
//  PlaceDetailsViewController.swift
//  DrinkHop
//
//  Created by Ross Duris on 2/21/15.
//  Copyright (c) 2015 duris.io. All rights reserved.
//

import UIKit

class DrinkSelectViewController: UIViewController {
    
    @IBOutlet weak var drinkTable:UITableView!
    @IBOutlet weak var addDrinkToolBar:UIToolbar!
    @IBOutlet weak var addDrinkButton:UIBarButtonItem!
    var photoData = UIImage()
    var drinkSearchController = UISearchController()
    var drinksArray:NSMutableArray = NSMutableArray()
    var filteredDrinksArray:NSMutableArray = NSMutableArray()
    var placesArray = [GooglePlace]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.drinkTable.delegate = self
        self.drinkTable.dataSource = self
        
        loadFilteredDrinks("")
        self.drinkTable.reloadData()
        
        self.addDrinkButton.title = ""
        self.addDrinkToolBar.backgroundColor = UIColor.whiteColor()
        self.addDrinkToolBar.tintColor = UIColor.whiteColor()
        self.addDrinkButton.tintColor = UIColor.whiteColor()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain,
            target: nil, action: nil)
    
        self.drinkSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "What'd you have to drink?"
            //controller.searchBar.text = ""
            controller.searchBar.autocorrectionType = UITextAutocorrectionType.Yes
            self.drinkTable.tableHeaderView = controller.searchBar
            return controller
        })()
    }
    
    override func viewWillAppear(animated: Bool) {
        let place = placesArray.first! as GooglePlace
        println(place.placeId)
        self.title = place.name
        self.drinkSearchController.searchBar.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        self.drinkSearchController.searchBar.becomeFirstResponder()
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
                    //println(drink.objectForKey("objectId"))
                    self.filteredDrinksArray.addObject(drink as PFObject)
                }
            } else {
                println("no drinks")
            }
            if self.filteredDrinksArray.count == 0 {
                let searchText = self.drinkSearchController.searchBar.text
                    self.addDrinkButton.title = "Add \(searchText) to DrinkHop"
                    self.addDrinkToolBar.backgroundColor = UIColor.lightGrayColor()
                    self.addDrinkButton.tintColor = UIColor.grayColor()              
                
            } else {
                self.addDrinkButton.title = ""
                self.addDrinkToolBar.backgroundColor = UIColor.whiteColor()
                self.addDrinkToolBar.tintColor = UIColor.whiteColor()
                self.addDrinkButton.tintColor = UIColor.whiteColor()
            }
            self.drinkTable.reloadData()
            self.searchDisplayController?.searchResultsTableView.reloadData()
        }
     
    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        self.drinkSearchController.searchBar.hidden = true
        self.drinkSearchController.searchBar.resignFirstResponder()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showReviewView" || segue.identifier == "newDrinkReview" {
            let reviewViewController = segue.destinationViewController as ReviewViewController            
            if self.filteredDrinksArray.count != 0 {
                let indexPath = self.drinkTable.indexPathForSelectedRow()!
                let drink = self.filteredDrinksArray[indexPath.row] as PFObject
                reviewViewController.drinkArray.append(drink as PFObject)
               // println(drink.objectForKey("objectId"))
            }else{
                reviewViewController.newDrinkName = self.drinkSearchController.searchBar.text
            }
            let place = placesArray.first! as GooglePlace
            reviewViewController.placeArray.append(place as GooglePlace)
            reviewViewController.photoData = self.photoData
            
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.drinkSearchController.searchBar.resignFirstResponder()
    }
    
}
