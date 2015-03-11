//
//  PlaceSearchViewController.swift
//  DrinkHop
//
//  Created by Ross Duris on 2/20/15.
//  Copyright (c) 2015 Pear Soda LLC. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class PlaceSearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var placesTable: UITableView!
    var placesSearchController = UISearchController()
    var placesArray:NSMutableArray = NSMutableArray()
    let locationManager = CLLocationManager()
    let dataProvider = GoogleDataProvider()
    var searchedKeyword:String! = ""
    var searchedTypes = ["bar"]
    var cords:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.024888, longitude: -82.722611)
    var currentLocation:CLLocation = CLLocation()
    var placeName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
            self.fetchNearbyPlaces(self.cords)

        self.placesTable.delegate = self
        self.placesTable.dataSource = self
        //self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.placesTable.reloadData()
        
        self.placesSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.delegate = self
            controller.searchBar.autocorrectionType = UITextAutocorrectionType.Yes
            //controller.searchBar.delegate = self
            self.placesTable.tableHeaderView = controller.searchBar
            return controller
        })()
        
        
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .Authorized || status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.placesSearchController.searchBar.hidden = false
    }

    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            fetchNearbyPlaces(location.coordinate)
            println(manager)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func triggerLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            if self.locationManager.respondsToSelector("requestWhenInUseAuthorization") {
                locationManager.requestWhenInUseAuthorization()
            } else {
                startUpdatingLocation()
            }
        }
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        self.placesArray.removeAllObjects()
        dataProvider.fetchPlacesNearCoordinate(coordinate, radius:50000, types: searchedTypes, keyword: searchedKeyword) { places in
            for object: AnyObject in places {
                if places.count == 0{
                    self.placesTable.reloadData()
                }
                let place:GooglePlace! = object as GooglePlace
                self.placesArray.addObject(place)
                println(place.placeType)
                
            }
            self.placesTable.reloadData()
            self.searchDisplayController?.searchResultsTableView.reloadData()
            println(self.placesArray.count)
        }
    }
    
   
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
            self.fetchNearbyPlaces(self.cords)
            self.placesTable.reloadData()
    }
    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        delay(2){
//            self.fetchNearbyPlaces(self.cords)
//        }
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "showPlace" {
            let placeDetailViewController = segue.destinationViewController as PlaceDetailsViewController
            let indexPath = self.placesTable.indexPathForSelectedRow()!
            let place = self.placesArray[indexPath.row] as GooglePlace
            placeDetailViewController.title = place.name
            self.placesSearchController.searchBar.hidden = true
            self.placesSearchController.searchBar.resignFirstResponder()
        }
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
