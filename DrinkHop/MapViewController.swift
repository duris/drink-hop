//
//  MapViewController.swift
//  DrinkHop
//
//  Created by Ross Duris on 2/23/15.
//  Copyright (c) 2015 Pear Soda LLC. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate,UISearchControllerDelegate, UISearchBarDelegate {
    
    
    let locationManager = CLLocationManager()
    let dataProvider = GoogleDataProvider()
    @IBOutlet weak var locationTable:UITableView!
    @IBOutlet weak var mapView:GMSMapView!
    var filteredPlaces:NSMutableArray = NSMutableArray()
    var coordinates:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.00, longitude: -0.00)
    var targetLocationArray = [CLLocationCoordinate2D]()
    var locationArray = [AnyObject]()
    var reviewArray = [Review]()
    var drinkDistances = [Double]()
    var distanceToReview = [Double]()
    var mapSearchController = UISearchController()
    var tempIndexRow = 0
    var selectedIndex = NSIndexPath(forRow: 0, inSection: 0)
    var tryThis = [CLLocationCoordinate2D]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        
        self.mapSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            //controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.placeholder = "Location"
            controller.searchBar.autocorrectionType = UITextAutocorrectionType.Yes
            //self.drinkTable.tableHeaderView = controller.searchBar
            let frame = CGRect(x: 0, y: 0, width: 240, height: 48)
            let titleView = UIView(frame: frame)
            controller.searchBar.backgroundImage = UIImage()
            controller.searchBar.frame = frame
            controller.searchBar.delegate = self
            controller.searchBar.sizeToFit()
            titleView.addSubview(controller.searchBar)
            self.navigationItem.titleView = titleView
            return controller
        })()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
        
        let placeMarker = marker as PlaceMarker
        
        
        if let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView {
            
            infoView.drinkNameLabel.text = placeMarker.review.drinkName
            infoView.placeNameLabel.text = "At " + placeMarker.review.placeName
            
//            if let photo = placeMarker.revew.photo {
//                infoView.placePhoto.image = photo
//            } else {
//                infoView.placePhoto.image = UIImage(named: "generic")
//            }
            
            return infoView
        } else {
            return nil
        }
    }
    
    @IBAction func refreshPlaces(sender: AnyObject) {
        self.mapView.clear()
        
        let target = CLLocationCoordinate2DMake(mapView.camera.target.latitude, mapView.camera.target.longitude)
        self.targetLocationArray.append(target)
 
        loadDrinks(mapView.camera.target)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func loadDrinks(coordinate: CLLocationCoordinate2D){
        
        var query : PFQuery = PFQuery(className: "Review")
        query.limit = 100
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.reviewArray.removeAll(keepCapacity: false)
                for object in objects{
                    let review:PFObject! = object as PFObject
                    
                    var getLat = review.objectForKey("lat") as Double!
                    var getLon = review.objectForKey("lon") as Double!
                    
                    //Create Location object from review coordinates
                    var reviewCooridinate = CLLocationCoordinate2DMake(getLat, getLon)
                    var drinkLocation: CLLocation = CLLocation(latitude: reviewCooridinate.latitude, longitude: reviewCooridinate.longitude)
                    
                    self.calDistance(drinkLocation)
                    
                    let distanceFromCameraToDrink = self.drinkDistances.first!
                    let distanceToDrink = self.distanceToReview.first!
                    let drinkName = review.objectForKey("drinkName") as String!
                    let placeName = review.objectForKey("placeName") as String!
                    let id = review.valueForKey("objectId") as String!
                    let tempIndex = NSIndexPath(forRow: 0, inSection: 0)
                    let reviewData:Review = Review(drinkName: drinkName, drinkDistance: distanceFromCameraToDrink, placeName: placeName, reviewLocation: drinkLocation, tempIndex: tempIndex, id:id)
                    
                    //Retrive cooridinates for the drink review and create a place marker if distance to drink review is less than specified distance
                    

                    self.reviewArray.append(reviewData as Review)
                    
                    
                        let marker = PlaceMarker(review: reviewData)                        
                        marker.map = self.mapView

                    
                }
            } else {
                println("error")
            }
            self.reviewArray.sort({$0.drinkDistance > $1.drinkDistance})
            self.searchDisplayController?.searchResultsTableView.reloadData()
            self.tempIndexRow = self.reviewArray.count + 2
            for review in self.reviewArray {
                review.tempIndex = NSIndexPath(forRow: self.tempIndexRow, inSection: 0)
                self.tempIndexRow = self.tempIndexRow - 1
            }
        }
    }
    
    func calDistance(placeLocation:CLLocation){
        self.drinkDistances.removeAll(keepCapacity: false)
        self.distanceToReview.removeAll(keepCapacity: false)
        //let location: AnyObject! = self.locationArray.first as AnyObject!
        
        var cameraCoordinate: CLLocation = CLLocation(latitude: self.mapView.camera.target.latitude, longitude: self.mapView.camera.target.longitude)
       
        var currentLocation: CLLocation = CLLocation(latitude: self.coordinates.latitude, longitude: self.coordinates.longitude)
        
        var distanceBetweenCameraLocation: CLLocationDistance =
        cameraCoordinate.distanceFromLocation(placeLocation as CLLocation)
        
        
        var distanceBetweenCurrentLocation: CLLocationDistance =
        currentLocation.distanceFromLocation(placeLocation as CLLocation)
        
        let longMiles = distanceBetweenCurrentLocation*0.000621371192
        
        let miles = String(format:"%.1f", longMiles)
        let mileToDrink = String(format:"%.1f", longMiles)
        
        self.drinkDistances.append(longMiles)
        self.distanceToReview.append(distanceBetweenCurrentLocation)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        
        var latestLocation: AnyObject = locations[locations.count - 1]
        self.locationArray.append(latestLocation)
        let latitude = latestLocation.coordinate.latitude
        let longitude = latestLocation.coordinate.longitude
        self.coordinates = CLLocationCoordinate2DMake(latitude, longitude)
//        self.targetLocation = CLLocationCoordinate2DMake(self.coordinates.latitude, self.coordinates.longitude)
        
        

        println("Yo \(targetLocationArray.count)")
        
        if targetLocationArray.count != 0 {
       mapView.camera = GMSCameraPosition(target: self.targetLocationArray.first!, zoom: 12, bearing: 0, viewingAngle: 0)
        } else {
            mapView.camera = GMSCameraPosition(target: self.coordinates, zoom: 12, bearing: 0, viewingAngle: 0)
        }

        //self.mapView.clear()
        //self.loadDrinks(self.coordinates)
        self.locationManager.stopUpdatingLocation()
        
    }
    

    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        return false
    }
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        // 1
        let googleMarker = mapView.selectedMarker as PlaceMarker
        let tempIndex = googleMarker.review.tempIndex
        self.selectedIndex = tempIndex
        self.targetLocationArray.removeAll(keepCapacity: false)
        let target = CLLocationCoordinate2DMake(mapView.camera.target.latitude, mapView.camera.target.longitude)
        self.targetLocationArray.append(target)
        self.performSegueWithIdentifier("closeMap", sender:googleMarker)
        
    }
    
//    func mapView(mapView: GMSMapView!, willMove gesture: Bool) {
//        if (gesture) {
//            mapView.selectedMarker = nil
//            self.coordinates = CLLocationCoordinate2DMake(self.mapView.camera.target.latitude, self.mapView.camera.target.longitude)
//        }
//    }
    
    func didTapMyLocationButtonForMapView(mapView: GMSMapView!) -> Bool {
        mapView.selectedMarker = nil
        return false
    }
    
    func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
//        self.coordinates = CLLocationCoordinate2DMake(mapView.camera.target.latitude, mapView.camera.target.longitude)
        self.targetLocationArray.removeAll(keepCapacity: false)
        let target = CLLocationCoordinate2DMake(mapView.camera.target.latitude, mapView.camera.target.longitude)
        self.targetLocationArray.append(target)
        println(target.latitude)
        println(target.longitude)
    }
    
    var mapRadius: Double {
        get {
            let region = mapView.projection.visibleRegion()
            let verticalDistance = GMSGeometryDistance(region.farLeft, region.nearLeft)
            let horizontalDistance = GMSGeometryDistance(region.farLeft, region.farRight)
            return max(horizontalDistance, verticalDistance)*0.5
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.locationTable.hidden = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.locationTable.hidden = true
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.mapSearchController.searchBar.resignFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        let test = self.targetLocationArray.count
        println("View is appearing")
        println(test)
        println("View done appearing")
        self.loadDrinks(self.coordinates)
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.targetLocationArray.count != 0 {
            let test = self.targetLocationArray.first!
            mapView.camera = GMSCameraPosition(target: test, zoom: 12, bearing: 0, viewingAngle: 0)
        } else {
            let myPos = CLLocationCoordinate2DMake(37.7833, -122.4167)
            mapView.camera = GMSCameraPosition(target: self.coordinates, zoom: 12, bearing: 0, viewingAngle: 0)
        }
    }
    
//    @IBAction func returnToMap(segue:UIStoryboardSegue) {
//        if segue.identifier == "close"{
//            let mainView = segue.sourceViewController as MainViewController
//            println("hey there")
//        }
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "closeMap" {
            let mainViewController = segue.destinationViewController as MainViewController
            if self.targetLocationArray.count != 0{
                mainViewController.targetLocation = self.targetLocationArray.first!
                println(mainViewController.targetLocation)
            }
        }
    }


}
