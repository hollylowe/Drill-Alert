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
    
    @IBAction func testSignInButtonTapped(sender: AnyObject) {
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        loginButton.hidden = true
        
        let session = SDISession(username: "capstone2015\\testuser", password: "StartUp!")
        session.login { (loggedIn) -> Void in
            if loggedIn {
                self.currentUser = User.getCurrentUser()
                
                self.activityIndicator.hidden = true
                self.activityIndicator.stopAnimating()
                self.loginButton.hidden = false
                self.performSegueWithIdentifier(self.loginToHomeSegueIdentifier, sender: self)
            }
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        self.loginButton.hidden = false
        
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        self.setupView()
        super.viewDidLoad()
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
    
    func setupView() {
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.view.frame
        backgroundImageView.addSubview(blurView)
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        if Reachability.isConnectedToNetwork() {
            self.performSegueWithIdentifier("LoginToLoginWebView", sender: nil)
        } else {
            let alertController = UIAlertController(
                title: "Error",
                message: "There is no internet connection.",
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
             let homeViewController = segue.destinationViewController as! HomeViewController
             homeViewController.currentUser = self.currentUser
        } else if segue.identifier == "LoginToLoginWebView" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let loginWebViewController = navigationController.viewControllers[0] as! LoginWebViewController

            loginWebViewController.delegate = self
        }
        
        super.prepareForSegue(segue, sender: sender)
    }

    func loginSuccess() {
        // User has logged in.
        //
        // Create a new SDISession.
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        loginButton.hidden = true
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            if let user = User.getCurrentUser() {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let application = UIApplication.sharedApplication()
                    if let appDelegate = application.delegate as? AppDelegate {
                        appDelegate.user = user
                        application.registerForRemoteNotifications()
                        
                        self.currentUser = user
                        
                        println(user.displayName)
                        self.activityIndicator.hidden = true
                        self.activityIndicator.stopAnimating()
                        self.performSegueWithIdentifier(self.loginToHomeSegueIdentifier, sender: self)
                    }
                })
                
            } else {
                println("Unable to get user.")
            }
        })
        
    }
}

