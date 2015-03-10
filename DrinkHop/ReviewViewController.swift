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
    
    
    @IBAction func submitReview(){
        let reviewText = self.thoughtsTextView.text
        let place = placeArray.first! as GooglePlace
        var review = PFObject(className:"Review")
        review["placeName"] = place.name
        review["placeId"] = place.placeId
        review["lat"] = place.coordinate.latitude
        review["lon"] = place.coordinate.longitude
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
        review.save()
        self.navigationController?.popViewControllerAnimated(true)
        //dismissViewControllerAnimated(true, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("main") as MainViewController
        presentViewController(vc, animated: false, completion: nil)
        
    }
  
    
    
    @IBAction func cancelReview(segue:UIStoryboardSegue){
        
    }


}
