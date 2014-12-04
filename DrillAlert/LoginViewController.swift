//
//  ViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/2/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import UIKit

// Google Plus
import AddressBook
import MediaPlayer
import AssetsLibrary
import CoreLocation
import CoreMotion


class LoginViewController: UIViewController, GPPSignInDelegate {
    
    @IBOutlet weak var passwordTextField: PaddedUITextField!
    @IBOutlet weak var usernameTextField: PaddedUITextField!
    @IBOutlet weak var fbSignInButton: UIButton!
    @IBOutlet weak var gpSignInButton: GPPSignInButton!
    @IBOutlet weak var sdiSignInButton: UIButton!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    let loginToHomeSegueIdentifier = "LoginToHomeSegue"
    var currentUser: User?
    
    func facebookRequestCompletionHandler(connection: FBRequestConnection!, user: AnyObject!, error: NSError!) {
        if error == nil {
            // TODO: Check userID against SDI Servers, or some other database to verify the user
            // has permission to access Drill Alert
            if let facebookUser = User.authenticateFacebookUser(user) {
                // Redirect to home page view
                
                self.currentUser = facebookUser
                self.performSegueWithIdentifier(self.loginToHomeSegueIdentifier, sender: self)
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
    
    func logInWithFacebookSuccess() {
        if FBSession.activeSession().isOpen {
            FBRequest.requestForMe().startWithCompletionHandler(facebookRequestCompletionHandler)
        }
    }
    
    @IBAction func fbSignInButtonTapped(sender: AnyObject) {
        // If the session state is any of the two "open" states when the button is clicked
        if FBSession.activeSession().state == FBSessionState.Open
            || FBSession.activeSession().state == FBSessionState.OpenTokenExtended {
                
                // Close the session and remove the access token from the cache
                // The session state handler (in the app delegate) will be called automatically
                FBSession.activeSession().closeAndClearTokenInformation()
                
                // If the session state is not any of the two "open" states when the button is clicked
        } else {
            // Open a session showing the user the login UI
            // You must ALWAYS ask for public_profile permissions when opening a session
            
            FBSession.openActiveSessionWithReadPermissions(["public_profile", "email"], allowLoginUI: true, completionHandler: { (session: FBSession!, state: FBSessionState, error: NSError!) -> Void in
                // Retrieve the app delegate
                var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
                appDelegate.sessionStateChanged(session, state: state, error: error)
            })

        }
    }
    class func storyboardIdentifier() -> String! {
        return "LoginViewController"
    }
    
    func dismissKeyboard() {
        self.passwordTextField.resignFirstResponder()
        self.usernameTextField.resignFirstResponder()
    }
    override func viewDidLoad() {
        // Google Plus
        let signIn = GPPSignIn.sharedInstance()
        signIn.shouldFetchGooglePlusUser = true
        signIn.shouldFetchGoogleUserEmail = true
        signIn.clientID = kClientId
        signIn.scopes = [kGTLAuthScopePlusLogin]
        signIn.delegate = self;
        
        // Keyboard Dismissing
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapRecognizer)
        
        
        setupView()
        
        // Check if user is already logged in, if they are, go
        // straight to the home view controller
        
        // Need to do some kind of session stuff here,
        // for example, we could check if there is a facebook session
        // open, if not, check if there is a google session open, 
        // if not, check if there is an SDI sesison open. If any of them
        // are open then skip the login view, otherwise show it
        super.viewDidLoad()
    }
    
    func setupView() {
        // SDI Text fields
        let borderColor = UIColor(red: 0.780, green: 0.780, blue: 0.804, alpha: 1.0).CGColor
        
        usernameTextField.layer.borderColor = borderColor
        usernameTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = borderColor
        passwordTextField.layer.borderWidth = 1.0
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.view.frame
        backgroundImageView.addSubview(blurView)
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        // Hide the navigation bar
        if let navigationController = self.navigationController {
            navigationController.navigationBar.hidden = true
        }
        self.dismissKeyboard()
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.dismissKeyboard()
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        self.dismissKeyboard()

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
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == loginToHomeSegueIdentifier {
            // let homeViewController = segue.destinationViewController as HomeViewController
            // homeViewController.currentUser = self.currentUser
            let tabBarController = segue.destinationViewController as MainTabBarController
            tabBarController.currentUser = currentUser
        }
        
        super.prepareForSegue(segue, sender: sender)
    }

    //MARK: Google Plus
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        if error != nil {
            // Show error stating they could not log in
            let alertController = UIAlertController(
                title: "Error",
                message: "Unable to sign in with Google Plus.",
                preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(
                title: "OK",
                style: .Default,
                handler: nil)
            
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            // TODO: Check userID against SDI Servers, or some other database to verify the user
            // has permission to access Drill Alert
            if let googlePlusUser = User.authenticateGooglePlusUser(auth) {
                // Redirect to home page view
                
                self.currentUser = googlePlusUser
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
    }
    
    func didDisconnectWithError(error: NSError!) {
        
        // Show error stating they could not log in
        let alertController = UIAlertController(
            title: "Error",
            message: "Unable to sign in with Google Plus.",
            preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(
            title: "OK",
            style: .Default,
            handler: nil)
        
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}

