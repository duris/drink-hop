//
//  UIViewExtension.swift
//  DrinkHop
//
//  Created by Ross Duris on 3/4/15.
//  Copyright (c) 2015 Pear Soda LLC. All rights reserved.
//

import UIKit

extension UIView {

    class func viewFromNibName(name: String) -> UIView? {
        let views = NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil)
        return views.first as? UIView
    }

}