//
//  DetailViewController.swift
//  DrinkHop
//
//  Created by Ross Duris on 3/16/15.
//  Copyright (c) 2015 duris.io. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var authorUsernameButton:UIButton!
    @IBOutlet weak var drinkNameLabel:UILabel!
    @IBOutlet weak var drinkDistanceLabel:UILabel!
    @IBOutlet weak var placeNameLabel:UILabel!
    @IBOutlet weak var drinkImageView:UIImageView!
    
    var review:Review!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        

 
    }
    
    override func viewWillAppear(animated: Bool) {
        let author = self.review.user as PFUser!
        let id = author.valueForKey("objectId") as String!
        
        
        self.drinkNameLabel.text = review.drinkName
        let miles = String(format:"%.0f", review.drinkDistance)
        self.drinkDistanceLabel.text = "\(miles) mi"
        self.placeNameLabel.text = "At " + review.placeName
        self.drinkImageView.image = review.image
        title = review.drinkName
        var query = PFUser.query()        
        query.getObjectInBackgroundWithId(id, block: {
            (object: PFObject!, error: NSError!) -> Void in
            if (error == nil) {
                let username = object.valueForKey("username") as String!                
                self.authorUsernameButton.setTitle(username, forState: UIControlState.Normal)
            } else {
                println("no user data")
            }
            
        })
        
      
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
