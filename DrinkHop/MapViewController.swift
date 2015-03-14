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
    var distanceToReview = [Double]()
    var mapSearchController = UISearchController()
    var tempIndexRow = 0
    var selectedIndex = NSIndexPath(forRow: 0, inSection: 0)
    var searchedTypes = ["bar", "restaurant"]
    var autoPlacesArray = [GoogleAutoPlace]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.locationTable.delegate = self
        self.locationTable.dataSource = self
        
        
        self.mapSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.searchBar.placeholder = "Location"
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.autocorrectionType = UITextAutocorrectionType.Yes
            let frame = CGRect(x: 0, y: 0, width: 240, height: 48)
            let titleView = UIView(frame: frame)
            controller.searchBar.backgroundImage = UIImage()
            controller.searchBar.frame = frame
            controller.searchBar.delegate = self
            controller.searchBar.sizeToFit()
            controller.searchBar.showsCancelButton = false
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
        
        self.targetLocationArray.removeAll(keepCapacity: false)
        self.reviewArray.removeAll(keepCapacity: false)
        let target = CLLocationCoordinate2DMake(mapView.camera.target.latitude, mapView.camera.target.longitude)
        self.targetLocationArray.append(target)
        loadDrinks(targetLocationArray.first!)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func loadDrinks(coordinate: CLLocationCoordinate2D){
        self.reviewArray.removeAll(keepCapacity: false)
        self.mapView.clear()
        var query : PFQuery = PFQuery(className: "Review")
        query.limit = 50
        var userGeoPoint :PFGeoPoint = PFGeoPoint(latitude: mapView.camera.target.latitude, longitude: mapView.camera.target.longitude)
        query.whereKey("location", nearGeoPoint: userGeoPoint, withinMiles: 20)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects{
                    let review:PFObject! = object as PFObject
                    
//                    var getLat = review.objectForKey("lat") as Double!
//                    var getLon = review.objectForKey("lon") as Double!
//                    
//                    //Create Location object from review coordinates
//                    var reviewCooridinate = CLLocationCoordinate2DMake(getLat, getLon)
                    let location = review.objectForKey("location") as PFGeoPoint!
                    var drinkLocation: CLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
//                    
                    self.calDistance(drinkLocation)
                    
                    //let distanceFromCameraToDrink = self.drinkDistances.first!
                    let distanceToDrink = self.distanceToReview.first!
                    let drinkName = review.objectForKey("drinkName") as String!
                    let placeName = review.objectForKey("placeName") as String!

                    if let imageFile = review.objectForKey("photo") as PFFile! {
                        imageFile.getDataInBackgroundWithBlock({
                            (imageData: NSData!, error: NSError!) -> Void in
                            if (error == nil) {
                                let image = UIImage(data:imageData)!
                                let tempIndex = NSIndexPath(forRow: 0, inSection: 0)
                                   let reviewData:Review = Review(drinkName: drinkName, drinkDistance: distanceToDrink, placeName: placeName, location: location,tempIndex:tempIndex, image:image)
                                self.reviewArray.append(reviewData as Review)
                                let marker = PlaceMarker(review: reviewData)
                                marker.map = self.mapView
                                println(self.reviewArray.count)
                                
                                self.reviewArray.sort({$0.drinkDistance > $1.drinkDistance})
                                self.searchDisplayController?.searchResultsTableView.reloadData()
                                self.tempIndexRow = self.reviewArray.count
                                for review in self.reviewArray {
                                    review.tempIndex = NSIndexPath(forRow: self.tempIndexRow, inSection: 0)
                                    self.tempIndexRow = self.tempIndexRow - 1
                                }
                            }
                            
                        })//getDataInBackgroundWithBlock - end
                    }else {
                        println("error: no photo file")
                    }
                    
                }
            } else {
                println("error")
            }

        }
    }
    
    func calDistance(placeLocation:CLLocation){
        self.distanceToReview.removeAll(keepCapacity: false)
        
        var currentLocation: CLLocation = CLLocation(latitude: self.mapView.myLocation.coordinate.latitude, longitude: self.mapView.myLocation.coordinate.longitude)
        
        var distanceBetweenCurrentLocation: CLLocationDistance =
        currentLocation.distanceFromLocation(placeLocation as CLLocation)
        let longMiles = distanceBetweenCurrentLocation*0.000621371192
        self.distanceToReview.append(longMiles)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var latestLocation: AnyObject = locations[locations.count - 1]
        self.locationArray.append(latestLocation)
        let latitude = latestLocation.coordinate.latitude
        let longitude = latestLocation.coordinate.longitude
        self.coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        
        self.locationManager.stopUpdatingLocation()
        
    }
    

    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        
        return false
    }
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        
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
        self.mapSearchController.searchBar.placeholder = "Current Location"
        loadDrinks(targetLocationArray.first!)
        return false
    }
    
    func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
        self.targetLocationArray.removeAll(keepCapacity: false)
        let target = CLLocationCoordinate2DMake(mapView.camera.target.latitude, mapView.camera.target.longitude)
        self.targetLocationArray.append(target)
  
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
        
        if self.reviewArray.count != 0 {
            for review in reviewArray{
                let marker = PlaceMarker(review: review)
                marker.map = self.mapView
            }
        }
        
        
        let test = self.targetLocationArray.count
   
        //self.loadDrinks(self.coordinates)
        if targetLocationArray.count != 0 {
            mapView.camera = GMSCameraPosition(target: self.targetLocationArray.first!, zoom: 12, bearing: 0, viewingAngle: 0)
        } else {
            mapView.camera = GMSCameraPosition(target: self.coordinates, zoom: 12, bearing: 0, viewingAngle: 0)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
     
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "closeMap" {
        
            let vc = segue.destinationViewController as MainViewController
            //let vc = navCon.topViewController as MainViewController
            
            if self.targetLocationArray.count != 0{
                vc.targetLocation = self.targetLocationArray.first!
            }
            if reviewArray.count != 0 {
                vc.drinksArray.removeAll(keepCapacity: false)
                for review in self.reviewArray {
                    vc.drinksArray.append(review)
                }
                vc.drinkTable.reloadData()
            }

        }
    }


}
