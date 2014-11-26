//
//  ViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/2/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBLoginViewDelegate {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var fbLoginView: FBLoginView!
    
    let loginToHomeSegueIdentifier = "LoginToHomeSegue"
    var currentUser: User?
    
    class func storyboardIdentifier() -> String! {
        return "LoginViewController"
    }
    
    override func viewDidLoad() {
        // Ask for public profile user permissions from facebook
        self.fbLoginView.readPermissions = ["public_profile"]
        
        // Hide the navigation bar
        if let navigationController = self.navigationController {
            navigationController.navigationBar.hidden = true
        }
        
        // Check if user is already logged in, if they are, go
        // straight to the home view controller
        
        // Need to do some kind of session stuff here,
        // for example, we could check if there is a facebook session
        // open, if not, check if there is a google session open, 
        // if not, check if there is an SDI sesison open. If any of them
        // are open then skip the login view, otherwise show it
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        if let user = User.authenticateSDIUsername(username, andPassword: password) {
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

extension LoginViewController: FBLoginViewDelegate {
    
    // FBLoginView has fetched public profile
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        
        // Check userID against SDI Servers, or some other database to verify the user
        // has permission to access Drill Alert
        if let facebookUser = User.authenticateFacebookUser(user) {
            // Redirect to home page view

            self.currentUser = facebookUser
            self.performSegueWithIdentifier(loginToHomeSegueIdentifier, sender: self)
        } else {
            // Show error stating they logged into facebook successfully but they
            // do not have access to Drill Alert
            let alertController = UIAlertController(
                title: "Error",
                message: "You have not been given access to Drill Alert.",
                preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(
                title: "OK",
                style: .Default,
                handler: nil)
            
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    // A person is logged in.
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        
    }
    
    // A person is logged out
    func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
        
    }
    
    // A communication or authorization error occurred.
    func loginView(loginView: FBLoginView!, handleError error: NSError!) {
        var alertMessage: String?
        var alertTitle: String?
        
        if FBErrorUtility.shouldNotifyUserForError(error) {
            alertTitle = "Facebook error"
            alertMessage = FBErrorUtility.userMessageForError(error)
        } else if FBErrorUtility.errorCategoryForError(error) == FBErrorCategory.AuthenticationReopenSession {
            alertTitle = "Session Error"
            alertMessage = "Your current session is no loner valid. Please log in again."
        } else {
            alertTitle = "Something went wrong"
            alertMessage = "Please try again later."
            println("Unexpected error: \(error)")
        }
        
        if let message = alertMessage {
            if let title = alertTitle {
                let alertController = UIAlertController(
                    title: title,
                    message: message,
                    preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(
                    title: "OK",
                    style: .Default,
                    handler: nil)
                
                alertController.addAction(defaultAction)
                
                presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
}

