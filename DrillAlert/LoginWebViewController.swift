//
//  LoginWebViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 2/23/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class LoginWebViewController: UIViewController, UIWebViewDelegate {
    let URLString = "https://drillalert.azurewebsites.net/"
    var delegate: LoginViewController!
    
    @IBOutlet weak var webView: UIWebView!
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        self.webView.delegate = self
        if let URLObject = NSURL(string: URLString) {
            let request = NSURLRequest(URL: URLObject)
            self.webView.loadRequest(request)
        }
        
        super.viewDidLoad()
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        var hasFedAuth = false
        var hasFedAuth1 = false
        
        if let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
            for cookie in cookies {
                if let HTTPCookie = cookie as? NSHTTPCookie {
                    if HTTPCookie.name == "FedAuth" {
                        hasFedAuth = true
                    } else if HTTPCookie.name == "FedAuth1" {
                        hasFedAuth1 = true
                    }
                }
            }
        }
        
        if hasFedAuth && hasFedAuth1 {
            self.dismissViewControllerAnimated(true, completion: self.delegate.loginSuccess)
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        var hasFedAuth = false
        var hasFedAuth1 = false
        
        if let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
            for cookie in cookies {
                if let HTTPCookie = cookie as? NSHTTPCookie {
                    if HTTPCookie.name == "FedAuth" {
                        hasFedAuth = true
                    } else if HTTPCookie.name == "FedAuth1" {
                        hasFedAuth1 = true
                    }
                }
            }
        }
        
        if hasFedAuth && hasFedAuth1 {
            self.dismissViewControllerAnimated(true, completion: self.delegate.loginSuccess)
        }
    }
    
    
}