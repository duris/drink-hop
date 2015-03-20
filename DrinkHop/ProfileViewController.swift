//
//  ProfileViewController.swift
//  DrinkHop
//
//  Created by Ross Duris on 3/16/15.
//  Copyright (c) 2015 Pear Soda LLC. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    

    @IBOutlet weak var usernameLabel:UILabel!
    @IBOutlet weak var drinkCountLabel:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let user = PFUser.currentUser(){
            self.usernameLabel.text = user.username
        }
       
        let user = PFUser.currentUser()
        
        var query = PFQuery(className:"Review")
        query.whereKey("user", equalTo:user)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.drinkCountLabel.text = "\(objects.count) Drinks Captured"
            } else {
                println("error loading data")
            }
        }
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closeProfile(segue:UIStoryboardSegue){
        if segue.identifier == "closeProfile" {


        }
    }
    
    @IBAction func signOut(){
        let user = PFUser.currentUser()
        PFUser.logOut()
        println("\(user) has signed out")
        var currentUser = PFUser.currentUser() // this will now be nil
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
