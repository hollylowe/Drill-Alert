//
//  ViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/2/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var sdiSignInButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    let loginToHomeSegueIdentifier = "LoginToHomeSegue"
    var currentUser: User?
    
    class func storyboardIdentifier() -> String! {
        return "LoginViewController"
    }
    
    func userLoggedIn(user: User) {
        self.currentUser = user
        activityIndicator.hidden = true
        activityIndicator.stopAnimating()
        self.performSegueWithIdentifier(loginToHomeSegueIdentifier, sender: self)
    }
    
    override func viewDidLoad() {
        
        // TODO: Remove this, for testing only
        
        /*
        let testCurve = Curve(id: 0, name: "test", tooltype: "test", units: "test", wellbore: Wellbore(id: 0, name: "test", well: Well(id: 0, name: "test", location: "test")))
        testCurve.getCurvePoints()
        
        let testWellboreView = WellboreView.getWellboreViewsForUserID("1")
        let wellboreView = testWellboreView[0]
        
        println(wellboreView.id)
        
        for panel in wellboreView.panels {
            println("panel id: \(panel.id)")
            for visualization in panel.visualizations {
                println("visualization id: \(visualization.id)")
            }
        }
        */
        
        setupView()
        
        // Check if user is already logged in, if they are, go
        // straight to the home view controller
        
        // Need to do some kind of session stuff here,
        // i.e. check if there is an SDI session open. If so
        // then skip the login view, otherwise show it
        super.viewDidLoad()
    }
    
    func setupView() {

        
        // SDI Text fields
        let borderColor = UIColor(red: 0.780, green: 0.780, blue: 0.804, alpha: 1.0).CGColor
        
        
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
        
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
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {

        self.performSegueWithIdentifier("LoginToLoginWebView", sender: self)
        /*
        self.dismissKeyboard()

        // Without web view
        var errorMessage: String?
        
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        if username.isEmpty {
            errorMessage = "Invalid username."
        } else if password.isEmpty {
            errorMessage = "Please enter a password."
        } else {
            activityIndicator.startAnimating()
            activityIndicator.hidden = false
            self.loginButton.enabled = false
            self.usernameTextField.enabled = false
            self.passwordTextField.enabled = false
            
            var newUserSession = UserSession()
            newUserSession.loginWithUsername(username, andPassword: password, andDelegate: self)
        }
        
        if errorMessage != nil {
            let alertController = UIAlertController(
                title: "Error",
                message: errorMessage,
                preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(
                title: "OK",
                style: .Default,
                handler: nil)
            
            alertController.addAction(defaultAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        */
    }
    
    func showInvalidLogInAlert() {
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
        self.loginButton.enabled = true
        
        let alertController = UIAlertController(
            title: "Error",
            message: "Invalid username or password.",
            preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(
            title: "OK",
            style: .Default,
            handler: nil)
        
        alertController.addAction(defaultAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
  
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == loginToHomeSegueIdentifier {
             let homeViewController = segue.destinationViewController as HomeViewController
             homeViewController.currentUser = self.currentUser
        } else if segue.identifier == "LoginToLoginWebView" {
            let navigationController = segue.destinationViewController as UINavigationController
            let loginWebViewController = navigationController.viewControllers[0] as LoginWebViewController

            loginWebViewController.delegate = self
        }
        
        super.prepareForSegue(segue, sender: sender)
    }

    func loginSuccess() {
        var user = User(firstName: "John", lastName: "Smith", id: "1", guid: "00000000-0000-0000-0000-000000000001", isAdmin: true)
        user.userSession = UserSession()
        if let userSession = user.userSession {
            let application = UIApplication.sharedApplication()
            if let appDelegate = application.delegate as? AppDelegate {
                appDelegate.userSession = userSession
                println("Registering for notifications...")
                application.registerForRemoteNotifications()
            }
        }
        
        self.userLoggedIn(user)
    }
}

