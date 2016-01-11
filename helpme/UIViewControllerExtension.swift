//
//  File.swift
//  Rivo
//
//  Created by Ximin Zhang on 1/6/16.
//  Copyright (c) 2016 Simon Fraser Univerity. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showErrorView(error: String) {
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
    }
}