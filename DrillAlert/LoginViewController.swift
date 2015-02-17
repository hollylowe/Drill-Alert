//
//  ViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/2/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: PaddedUITextField!
    @IBOutlet weak var usernameTextField: PaddedUITextField!
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
    
    func dismissKeyboard() {
        self.passwordTextField.resignFirstResponder()
        self.usernameTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        
        // Keyboard Dismissing
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapRecognizer)
        
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
    }
    
    func showInvalidLogInAlert() {
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
        
        
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
        }
        
        super.prepareForSegue(segue, sender: sender)
    }

}

