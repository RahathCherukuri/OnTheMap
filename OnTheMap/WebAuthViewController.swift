//
//  WebAuthViewController.swift
//  OnTheMap
//
//  Created by Rahath cherukuri on 2/22/16.
//  Copyright © 2016 Rahath cherukuri. All rights reserved.
//

import UIKit

class WebAuthViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var urlRequest: NSURLRequest? = nil
    var completionHandler : ((success: Bool, errorString: String?) -> Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        
        self.navigationItem.title = "Udacity Auth"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelAuth")

    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if urlRequest != nil {
            self.webView.loadRequest(urlRequest!)
        }
    }
    
    // MARK: Cancel Auth Flow
    
    func cancelAuth() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}


// MARK: - WebAuthViewController: UIWebViewDelegate

extension WebAuthViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(webView: UIWebView) {
        print("webView URL: ", webView.request?.URL?.absoluteString)
//        if ( webView.request!.URL!.absoluteString == "\(TMDBClient.Constants.AuthorizationURL)\(requestToken!)/allow") {
//            self.dismissViewControllerAnimated(true, completion: { () -> Void in
//                self.completionHandler!(success: true, errorString: nil)
//            })
//        }
    }
    
}