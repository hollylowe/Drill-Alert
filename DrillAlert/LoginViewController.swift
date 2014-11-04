//
//  ViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/2/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    var delegate: HomeViewController!
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        // Obviously replace this with a legit login system
        if username == "admin" {
            // Load admin view
            self.delegate.loggedIn = true
            self.dismissViewControllerAnimated(true, completion: nil)
        } else if username == "user" {
            // Load user view
            self.delegate.loggedIn = true
            self.delegate.reloadWells()
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Error", message: "Incorrect username or password.", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    class func storyboardIdentifier() -> String! {
        return "LoginViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

