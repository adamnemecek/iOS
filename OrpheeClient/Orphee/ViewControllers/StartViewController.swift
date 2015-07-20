//
//  StartViewController.swift
//  Orphee
//
//  Created by Jeromin Lebon on 27/06/2015.
//  Copyright (c) 2015 __ORPHEE__. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class StartViewController: UIViewController {
    @IBOutlet var loginField: UITextField!
    @IBOutlet var mdpField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        navigationController!.navigationBar.barTintColor = UIColor(red: (13/255.0), green: (71/255.0), blue: (161/255.0), alpha: 1.0)
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    func requestConnectWithToken(url: String, requestMethod: String, token: String) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var response: NSURLResponse?
        
        request.HTTPMethod = requestMethod
        request.setValue("application/x-www-form-urlencoded",
            forHTTPHeaderField: "Content-Type")
        if (!token.isEmpty) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        var err: NSError
        var responseData = NSURLConnection.sendSynchronousRequest(request,returningResponse:&response, error:nil) as NSData?
        if let httpResponse = response as? NSHTTPURLResponse {
            println("error \(httpResponse.statusCode)")
            if (httpResponse.statusCode == 200){
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(responseData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                NSUserDefaults.standardUserDefaults().setObject(jsonResult["token"], forKey: "token")
                performSegueWithIdentifier("toMenu", sender: nil)
            }
            else{
                let alertView = UIAlertView(title: "Erreur", message: "Connexion impossible, réessayez.", delegate: self, cancelButtonTitle: "Ok")
                alertView.alertViewStyle = .Default
                alertView.show()
            }
        }
    }
    
    func checkLoginAndPasswd() {
        if (!loginField.text.isEmpty && !mdpField.text.isEmpty){
            let param = "\(loginField.text):\(mdpField.text):local"
            let utf8str = param.dataUsingEncoding(NSUTF8StringEncoding)
            let token = utf8str!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            println(token)
            let url = "https://orpheeapi.herokuapp.com/api/login"
            let method = "POST"
            requestConnectWithToken(url, requestMethod: method, token: token)
        }
        else{
            let alertView = UIAlertView(title: "Erreur", message: "Tous les champs ne sont pas correctement remplis.", delegate: self, cancelButtonTitle: "Ok")
            alertView.alertViewStyle = .Default
            alertView.show()
        }
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        checkLoginAndPasswd()
    }
}