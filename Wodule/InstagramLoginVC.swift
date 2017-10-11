//
//  InstagramLoginVC.swift
//  Wodule
//
//  Created by QTS Coder on 10/10/17.
//  Copyright © 2017 QTS. All rights reserved.
//

import UIKit

class InstagramLoginVC: UIViewController {
    
    @IBOutlet weak var webViewLogin: UIWebView!
    
    var tokencallback: ((_ token: String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        unSignedRequest()
        webViewLogin.delegate = self
    }
    
    func unSignedRequest()
    {
        let authURL = String(format: "https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token", arguments: [InstagramAPI.INSTAGRAM_CLIENT_ID, InstagramAPI.INSTAGRAM_REDIRECT_URI])
        let urlRequest =  URLRequest.init(url: URL.init(string: authURL)!)
        print(authURL)
        webViewLogin.loadRequest(urlRequest)

    }
    
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        
        let requestURLString = (request.url?.absoluteString)! as String
        
        if requestURLString.hasPrefix(InstagramAPI.INSTAGRAM_REDIRECT_URI) {
            
            if let range: Range<String.Index> = requestURLString.range(of: "#access_token=")
            {
                handleAuth(authToken: requestURLString.substring(from: range.upperBound))
                return false
            }
            
        }
        
        return true
    }
    
    func handleAuth(authToken: String)  {
        print("Instagram authentication token ==", authToken)
        tokencallback?(authToken)
        dismiss(animated: true, completion: nil)
    }
    
}

extension InstagramLoginVC: UIWebViewDelegate
{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        self.loadingShow()
        return checkRequestForCallbackURL(request: request)
        
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.loadingHide()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        webViewDidFinishLoad(webView)
        dismiss(animated: true, completion: nil)

    }
    
}
