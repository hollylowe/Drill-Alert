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
    
    let loginToHomeSegueIdentifier = "LoginToHomeSegue"
    var currentUser: User?
    
    class func storyboardIdentifier() -> String! {
        return "LoginViewController"
    }
    
    override func viewDidLoad() {
        // Check if user is already logged in, if they are, go 
        // straight to the home view controller
        if let navigationController = self.navigationController {
            navigationController.navigationBar.hidden = true
        }
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        if let user = User.authenticateUsername(username, andPassword: password) {
            self.currentUser = user
            self.performSegueWithIdentifier(loginToHomeSegueIdentifier, sender: self)
        } else {
            let alertController = UIAlertController(
                title: "Error",
                message: "Incorrect username or password.",
                preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(
                title: "OK",
                style: .Default,
                handler: nil)
            
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == loginToHomeSegueIdentifier {
            let homeViewController = segue.destinationViewController as HomeViewController
            homeViewController.currentUser = self.currentUser
        }
        
        super.prepareForSegue(segue, sender: sender)
    }

}

