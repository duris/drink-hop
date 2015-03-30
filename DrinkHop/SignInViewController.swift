//
//  SignInViewController.swift
//  DrinkHop
//
//  Created by Ross Duris on 3/20/15.
//  Copyright (c) 2015 duris.io. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    @IBOutlet weak var usernameTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signIn(){
        PFUser.logInWithUsernameInBackground(usernameTextField.text, password:passwordTextField.text) {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navCon = storyboard.instantiateViewControllerWithIdentifier("profile") as UINavigationController
                self.presentViewController(navCon, animated: true, completion: nil)
            } else {
                println("error")
            }
        }
    }
    

}
