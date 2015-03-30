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
    @IBOutlet weak var userNameLabel:UILabel!
    
    var author:PFUser!
    var review:Review!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.author = self.review.user as PFUser!

 
    }
    
    override func viewWillAppear(animated: Bool) {
        let id = author.valueForKey("objectId") as String!
        println(id)
        var query = PFUser.query()
        let user = query.getObjectWithId(id) as PFUser!
        let userName = user.valueForKey("username") as String!
        println(userName)
        self.userNameLabel.text = userName
        self.authorUsernameButton.titleLabel?.text = userName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func viewAuthorProfile(author:PFUser){
        
    }

}
