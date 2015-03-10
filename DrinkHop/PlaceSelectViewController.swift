//
//  PlaceSelectViewController.swift
//  DrinkHop
//
//  Created by Ross Duris on 2/21/15.
//  Copyright (c) 2015 Pear Soda LLC. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class PlaceSelectViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var placesTable: UITableView!
    var photoData = UIImage()
    var placesSearchController = UISearchController()
    var placesArray:NSMutableArray = NSMutableArray()
    var placeDistances = [AnyObject]()
    let locationManager = CLLocationManager()
    let dataProvider = GoogleDataProvider()
    var searchedKeyword = ""
    var searchedTypes = ["bar", "restaurant"]
    var latitude:CLLocationDegrees = CLLocationDegrees()
    var longitude:CLLocationDegrees = CLLocationDegrees()
    var coordinates:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.00, longitude: -0.00)
    var locationArray = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.placesTable.delegate = self
        self.placesTable.dataSource = self
        
        
        
        self.placesSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "Where'd you get it?"
            controller.searchBar.delegate = self
            controller.searchBar.showsCancelButton = false
            controller.searchBar.autocorrectionType = UITextAutocorrectionType.No
            self.placesTable.tableHeaderView = controller.searchBar
            return controller
        })()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain,
            target: nil, action: nil)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.placesSearchController.searchBar.hidden = false
        
        self.placesTable.reloadData()
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
            
            var latestLocation: AnyObject = locations[locations.count - 1]
            self.locationArray.append(latestLocation)
            self.latitude = latestLocation.coordinate.latitude
            self.longitude = latestLocation.coordinate.longitude
            self.coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            self.fetchNearbyPlaces(self.coordinates)
            self.locationManager.stopUpdatingLocation()
        
    }
    
    
    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        self.placesArray.removeAllObjects()
        self.placeDistances.removeAll(keepCapacity: false)
        dataProvider.fetchPlacesNearCoordinate(coordinate, types: searchedTypes, keyword: searchedKeyword) { places in
            for object: AnyObject in places {
                if places.count == 0{
                    self.placesTable.reloadData()
                }
                let place:GooglePlace! = object as GooglePlace
                self.placesArray.addObject(place)
                println(place.placeType)
                
                
                var getLat: CLLocationDegrees = place.coordinate.latitude
                var getLon: CLLocationDegrees = place.coordinate.longitude
                var placeLocation: CLLocation = CLLocation(latitude: getLat, longitude: getLon)
                
                self.calDistance(placeLocation)
                
            }
            self.placesTable.reloadData()
            self.searchDisplayController?.searchResultsTableView.reloadData()
            println(self.placesArray.count)
            println(self.placeDistances.count)
        }
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.fetchNearbyPlaces(self.coordinates)
        self.placesTable.reloadData()
    }
    
    //    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    //        delay(2){
    //            self.fetchNearbyPlaces(self.cords)
    //        }
    //    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showPlace" {
            let placeDetailViewController = segue.destinationViewController as DrinkSelectViewController
            let indexPath = self.placesTable.indexPathForSelectedRow()!
            placeDetailViewController.photoData = self.photoData
            let place = self.placesArray[indexPath.row] as GooglePlace
            placeDetailViewController.placesArray.append(place as GooglePlace)
  
        }
        self.placesSearchController.searchBar.hidden = true
        self.placesSearchController.searchBar.resignFirstResponder()
    }
    
    func calDistance(placeLocation:CLLocation){
        let location: AnyObject! = self.locationArray.first as AnyObject!
        var distanceBetween: CLLocationDistance =
        location.distanceFromLocation(placeLocation as CLLocation)
        let longMiles = distanceBetween*0.000621371192
        let miles = String(format:"%.1f", longMiles)
        self.placeDistances.append(miles)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.placesSearchController.searchBar.resignFirstResponder()
    }
    
    @IBAction func loadMorePlaces() {
        fetchNextPage()
    }
    
    func fetchNextPage() {
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.placesSearchController.searchBar.hidden = true
        self.placesSearchController.searchBar.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
