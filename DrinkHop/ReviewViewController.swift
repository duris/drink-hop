//
//  ReviewViewController.swift
//  DrinkHop
//
//  Created by Ross Duris on 2/21/15.
//  Copyright (c) 2015 Pear Soda LLC. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    @IBOutlet weak var placeNameLabel:UILabel!
    @IBOutlet weak var drinkNameLabel:UILabel!
    @IBOutlet weak var thoughtsTextView:UITextView!
    @IBOutlet weak var photoImageView:UIImageView!
    var placeArray = [GooglePlace]()
    var drinkArray = [PFObject]()
    var newDrinkName = ""
    var photoData = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoImageView.image = self.photoData
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = "What's your opinion?"
        
        let place = placeArray.first! as GooglePlace
        if newDrinkName != "" {
            self.drinkNameLabel.text! = newDrinkName
        }else{

            let drink = drinkArray.first! as PFObject!
            self.drinkNameLabel.text! = drink.objectForKey("name") as String!
        }
        
        self.placeNameLabel.text! = place.name
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "submitReview" {
            let reviewText = self.thoughtsTextView.text
            let place = placeArray.first! as GooglePlace
            var review = PFObject(className:"Review")
            review["placeName"] = place.name
            review["placeId"] = place.placeId
            let imageData:NSData = UIImageJPEGRepresentation(self.photoImageView.image, 0.9)
            let imageFile:PFFile = PFFile(data: imageData)
            review["photo"] = imageFile
            let point = PFGeoPoint(latitude:place.coordinate.latitude, longitude:place.coordinate.longitude)
            review["location"] = point
            if newDrinkName != "" {
                let newDrink = PFObject(className: "Drink")
                review["drinkName"] = self.newDrinkName as String!
                newDrink["name"] = self.newDrinkName as String!
                newDrink.save()
            } else {
                let drink = drinkArray.first! as PFObject!
                review["drinkName"] = drink.objectForKey("name") as String!
                println(drink.objectForKey("objectId"))
            }
            review.saveInBackgroundWithBlock {
                (success: Bool, error: NSError!) -> Void in
                if (success) {
                    // The object has been saved.
                } else {
                    // There was a problem, check error.description
                }
            }
            
            self.navigationController?.popToRootViewControllerAnimated(false)
            self.dismissViewControllerAnimated(true, completion: nil)
            
            
        }
    }
    
    
    
    
    
    @IBAction func cancelReview(segue:UIStoryboardSegue){
        
    }


}
