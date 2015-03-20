//
//  SignUpViewController.swift
//  DrinkHop
//
//  Created by Ross Duris on 3/19/15.
//  Copyright (c) 2015 Pear Soda LLC. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    @IBOutlet weak var emailTextField:UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signUp() {
        var user = PFUser()
        user.username = userNameTextField.text
        user.password = passwordTextField.text
        user.email = emailTextField.text
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
               println("\(user.username) has signed in")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navCon = storyboard.instantiateViewControllerWithIdentifier("profile") as UINavigationController
                self.presentViewController(navCon, animated: true, completion: nil)
            } else {
               println("error")
            }
        }
    }
}
