//
//  AppDelegate.swift
//  DrinkHop
//
//  Created by Ross Duris on 2/20/15.
//  Copyright (c) 2015 Pear Soda LLC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    let googleApiKey = "AIzaSyBKvacsILX1FNuvXL4oMioe2fx08rtQM2k"
    
    
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {

        Parse.setApplicationId("va3DDL1vXTgHWJyfUiO3rCBybdxck2LB48v8BXBD", clientKey: "ir27EamcTPZePpVNKizSqBUo7H0gYO4KSzeSZ5Lv")
                    
        GMSServices.provideAPIKey(googleApiKey)
        return true
    }
    
    
}