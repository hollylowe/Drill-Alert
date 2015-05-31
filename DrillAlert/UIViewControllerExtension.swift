//
//  UIViewControllerExtension.swift
//  DrillAlert
//
//  Created by Lucas David on 5/30/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    var navBarHairlineImageView: UIImageView? {
        var result: UIImageView?
        
        if let navigationController = self.navigationController {
            result = self.findHairlineImageViewUnder(navigationController.navigationBar)
        }
        
        return result
    }
    
    func findHairlineImageViewUnder(view: UIView) -> UIImageView? {
        if view.isKindOfClass(UIImageView) && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        } else {
            for subview in view.subviews {
                var imageView = self.findHairlineImageViewUnder(subview as! UIView)
                if imageView != nil {
                    return imageView
                }
            }
            return nil
        }
    }
}