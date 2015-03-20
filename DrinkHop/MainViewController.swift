//
//  MainViewController.swift
//  DrinkHop
//
//  Created by Ross Duris on 2/22/15.
//  Copyright (c) 2015 Pear Soda LLC. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

class MainViewController: UIViewController,CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var cameraButton:UIButton!
    @IBOutlet weak var libraryButton:UIButton!
    @IBOutlet weak var drinkTable:UITableView!
    @IBOutlet weak var mapViewButton:UIBarButtonItem!
    @IBOutlet weak var overlayView:UIView!
    let selectedPhoto = UIImageView()
    let picker = UIImagePickerController()
    var mainSearchController = UISearchController()
    var drinksArray = [Review]()
    let locationManager = CLLocationManager()
    var myDistanceToDrink = [Double]()
    var selectedIndex = NSIndexPath(forRow: 0, inSection: 0)
    var mapCameraDistanceToDrink = [Double]()
    var coordinates:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.00, longitude: -0.00)
    var myLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.00, longitude: -0.00)
    var targetLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.00, longitude: -0.00)
    var 🍕 = 0.0
    
    var filteredReviewsArray = [Review]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.drinkTable.delegate = self
        self.drinkTable.dataSource = self
        self.picker.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        delay(0.1){
        self.loadDrinks()
        }
        
        
        
        
         self.mainSearchController.searchBar.showsCancelButton = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain,
            target: nil, action: nil)
        
        self.mainSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.placeholder = "Drinks"
            controller.searchBar.autocorrectionType = UITextAutocorrectionType.No
            //self.drinkTable.tableHeaderView = controller.searchBar
            let frame = CGRect(x: 0, y: 0, width: 240, height: 48)
            let titleView = UIView(frame: frame)
            controller.searchBar.backgroundImage = UIImage()
            controller.searchBar.frame = frame
            controller.searchBar.delegate = self
            controller.searchBar.showsCancelButton = false
        
            
            //controller.searchBar.sizeToFit()
            titleView.addSubview(controller.searchBar)
            self.navigationItem.titleView = titleView
            return controller
        })()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.mainSearchController.searchBar.hidden = false
        self.drinkTable.reloadData()
    }
    
    @IBAction func refreshTable(){
        self.loadDrinks()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.delay(0.1){
            if self.targetLocation.latitude == 0.00 {
                self.reverseGeocodeCoordinate(self.myLocation)
            }else{
                self.reverseGeocodeCoordinate(self.targetLocation)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //Create func loadFilteredDrinks()
    
    
    func loadDrinks(){
        self.drinksArray.removeAll(keepCapacity: false)
        var query : PFQuery = PFQuery(className: "Review")
        query.limit = 50
        var userGeoPoint : PFGeoPoint = PFGeoPoint()
        if self.targetLocation.latitude != 0.00{
          userGeoPoint = PFGeoPoint(latitude: self.targetLocation.latitude, longitude: self.targetLocation.longitude)
        }else{
            userGeoPoint = PFGeoPoint(latitude: self.myLocation.latitude, longitude: self.myLocation.longitude)
        }
        query.whereKey("location", nearGeoPoint: userGeoPoint, withinMiles: 20)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects{
                    let drink:PFObject! = object as PFObject
        
                    let location = drink.objectForKey("location") as PFGeoPoint!
                    var drinkLocation: CLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                    self.calDistanceToMyLocation(drinkLocation)
                    let distanceToDrink = self.myDistanceToDrink.first!
                    let drinkName = drink.objectForKey("drinkName") as String!
                    let placeName = drink.objectForKey("placeName") as String!
                    let tempIndex = NSIndexPath(forRow: 1, inSection: 0)
                    if let imageData = drink.objectForKey("photo") as PFFile! {
                        imageData.getDataInBackgroundWithBlock({
                            (data: NSData!, error: NSError!) -> Void in
                            if (error == nil) {
                                let image = UIImage(data:data)!
                                let reviewData:Review = Review(drinkName: drinkName, drinkDistance: distanceToDrink, placeName: placeName, location: location,tempIndex:tempIndex, image:image)
                                
                                self.drinksArray.append(reviewData as Review)
                                self.drinksArray.sort({$0.drinkDistance > $1.drinkDistance})
                                self.drinkTable.reloadData()
                            }
                            
                        })//getDataInBackgroundWithBlock - end
                    }else {
                        let image = UIImage(named: "drink")!
                        let reviewData:Review = Review(drinkName: drinkName, drinkDistance: 0.00, placeName: placeName, location: location,tempIndex:tempIndex, image:image)
                        
                        
                        self.drinksArray.append(reviewData as Review)
                        //self.drinksArray.sort({$0.drinkDistance > $1.drinkDistance})
                        self.drinkTable.reloadData()
                    }
          
                }
                
            } else {
                println("error")
            }
        }
    }
    
    func loadFilteredDrinks(searchText:String){
        self.filteredReviewsArray.removeAll(keepCapacity: false)
        var query : PFQuery = PFQuery(className: "Review")
        query.limit = 50
        var userGeoPoint : PFGeoPoint = PFGeoPoint()
        if self.targetLocation.latitude != 0.00{
            userGeoPoint = PFGeoPoint(latitude: self.targetLocation.latitude, longitude: self.targetLocation.longitude)
        }else{
            userGeoPoint = PFGeoPoint(latitude: self.myLocation.latitude, longitude: self.myLocation.longitude)
        }
        query.whereKey("location", nearGeoPoint: userGeoPoint, withinMiles: 20)
        query.whereKey("drinkName", containsString: searchText)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects{
                    let drink:PFObject! = object as PFObject
                    
                    let location = drink.objectForKey("location") as PFGeoPoint!
                    var drinkLocation: CLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                    self.calDistanceToMyLocation(drinkLocation)
                    let distanceToDrink = self.myDistanceToDrink.first!
                    let drinkName = drink.objectForKey("drinkName") as String!
                    let placeName = drink.objectForKey("placeName") as String!
                    let tempIndex = NSIndexPath(forRow: 1, inSection: 0)
                    if let imageData = drink.objectForKey("photo") as PFFile! {
                        imageData.getDataInBackgroundWithBlock({
                            (data: NSData!, error: NSError!) -> Void in
                            if (error == nil) {
                                let image = UIImage(data:data)!
                                let reviewData:Review = Review(drinkName: drinkName, drinkDistance: distanceToDrink, placeName: placeName, location: location,tempIndex:tempIndex, image:image)
                                
                                self.filteredReviewsArray.append(reviewData as Review)
                                self.filteredReviewsArray.sort({$0.drinkDistance > $1.drinkDistance})
                                self.drinkTable.reloadData()
                            }
                            
                        })//getDataInBackgroundWithBlock - end
                    }else {
                        let image = UIImage(named: "drink")!
                        let reviewData:Review = Review(drinkName: drinkName, drinkDistance: 0.00, placeName: placeName, location: location,tempIndex:tempIndex, image:image)
                        
                        
                        self.filteredReviewsArray.append(reviewData as Review)
                        //self.drinksArray.sort({$0.drinkDistance > $1.drinkDistance})
                        
                        self.drinkTable.reloadData()
                        self.mainSearchController.searchDisplayController?.searchResultsTableView.reloadData()
                    }
                    
                }
                
            } else {
                println("error")
            }
        }
    }

    
    
    override func viewWillDisappear(animated: Bool) {
        self.mainSearchController.searchBar.hidden = true
        self.mainSearchController.searchBar.resignFirstResponder()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        self.locationManager.startUpdatingLocation()
        let currentLocation: AnyObject = locations.first! as AnyObject
        println(currentLocation.coordinate.latitude)
        println(currentLocation.coordinate.longitude)
        self.myLocation = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func calDistanceToMyLocation(placeLocation:CLLocation){
        self.myDistanceToDrink.removeAll(keepCapacity: false)
        let location: CLLocation = CLLocation(latitude: self.myLocation.latitude, longitude:self.myLocation.longitude)
        var distanceBetween: CLLocationDistance =
        location.distanceFromLocation(placeLocation as CLLocation)
        let longMiles = distanceBetween*0.000621371192
        let miles = String(format:"%.1f", longMiles)
        self.myDistanceToDrink.append(longMiles)
    }
    
    func calDistanceToMapCamera(placeLocation:CLLocation){
        self.mapCameraDistanceToDrink.removeAll(keepCapacity: false)
        let location: CLLocation = CLLocation(latitude: self.targetLocation.latitude, longitude:self.targetLocation.longitude)
        var distanceBetween: CLLocationDistance =
        location.distanceFromLocation(placeLocation as CLLocation)
        let longMiles = distanceBetween*0.000621371192
        let miles = String(format:"%.1f", longMiles)
        self.mapCameraDistanceToDrink.append(longMiles)
    }
    
    
        
    @IBAction func close(segue:UIStoryboardSegue){
        if segue.identifier == "closeMap"{

            let mapView = segue.sourceViewController as MapViewController
            
            mapView.targetLocationArray.removeAll(keepCapacity: false)
            mapView.targetLocationArray.append(self.targetLocation)
            let target = mapView.targetLocationArray.first!
            self.targetLocation.latitude = target.latitude
            self.targetLocation.longitude = target.longitude

            delay(1){
                if mapView.selectedIndex != NSIndexPath(forRow: 0, inSection: 0) {
                    self.selectedIndex = mapView.selectedIndex
                    let row = self.selectedIndex.row - 2
                    println(self.selectedIndex.row)
                    println(self.drinksArray.count)
                    if self.selectedIndex.row == self.drinksArray.count {
                        let path = NSIndexPath(forRow: self.selectedIndex.row - 1, inSection: 0)
                        self.drinkTable.scrollToRowAtIndexPath(path, atScrollPosition: .Bottom, animated: true)
                    }else{
                        self.drinkTable.scrollToRowAtIndexPath(self.selectedIndex, atScrollPosition: .Bottom, animated: true)
                    }
                    
                }
            }
        }
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "openMap" {
            

            let navCon = segue.destinationViewController as UINavigationController
            let vc = navCon.topViewController as MapViewController

            vc.targetLocationArray.removeAll(keepCapacity: false)
            
            if self.targetLocation.latitude == 0.00{                
                vc.targetLocationArray.append(self.myLocation)
                let test = vc.targetLocationArray.first!
            } else {
                vc.targetLocationArray.append(self.targetLocation)
            }
            
            if drinksArray.count != 0 {
                vc.tempIndexRow = vc.reviewArray.count
                for review in drinksArray {
                    vc.tempIndexRow = vc.tempIndexRow + 1
                    vc.reviewArray.append(review)
                    review.tempIndex = NSIndexPath(forRow: vc.tempIndexRow, inSection: 0)
                }
            }
        }
    }
    
    @IBAction func showPhotoOptions(sender: UIBarButtonItem){
        if self.overlayView.hidden == true{
            self.overlayView.hidden = false
        } else {       
            self.overlayView.hidden = true
        }
    }
    
    @IBAction func photoFromLibrary(sender: UIBarButtonItem){
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        picker.modalPresentationStyle = .Popover
        presentViewController(picker, animated: true, completion: nil)
        picker.popoverPresentationController?.barButtonItem = sender
        hideOverlay()
    }
    
    @IBAction func shootPhoto(sender: UIBarButtonItem) {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.modalPresentationStyle = .Popover
        picker.cameraCaptureMode = .Photo
        presentViewController(picker, animated: true, completion: nil)
        hideOverlay()
    }
    
    //UIImage Picker Delegates

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var chosenImage = info[UIImagePickerControllerOriginalImage] as UIImage
        //myImageView.contentMode = .ScaleAspectFit
        self.selectedPhoto.image = chosenImage
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("placeSelect") as PlaceSelectViewController
        vc.navigationController?.title = "Add Review"
        vc.photoData = chosenImage
        picker.pushViewController(vc, animated: true)     
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            
            if let address = response?.firstResult() {
                let lines = address.lines as [String]
                var area = lines[1]
                var city = split(area) {$0 == ","}
                var state = split(area){$0 == " "}
                let stateAbbr = state[state.count - 2]
                self.mapViewButton.title = "\(city.first!)"
            }
            
        }
    }
    
    func hideOverlay(){
        delay(1){
            self.overlayView.hidden = true
        }
    }
    
    @IBAction func closeProfile(segue:UIStoryboardSegue){
        if segue.identifier == "closeProfile" {
            
            
        }
    }

    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.mainSearchController.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.mainSearchController.searchBar.resignFirstResponder()
        self.mainSearchController.searchBar.text=""
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let searchText = self.mainSearchController.searchBar.text
        self.mainSearchController.searchBar.showsCancelButton = false
        self.loadFilteredDrinks(self.mainSearchController.searchBar.text)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.mainSearchController.searchBar.showsCancelButton = false
    }
    
    @IBAction func openProfile(){
        if PFUser.currentUser() == nil{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navCon = storyboard.instantiateViewControllerWithIdentifier("signIn") as UINavigationController
            self.presentViewController(navCon, animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navCon = storyboard.instantiateViewControllerWithIdentifier("profile") as UINavigationController
            self.presentViewController(navCon, animated: true, completion: nil)
        }
    }
   
    
    
}


