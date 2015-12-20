//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Boris Alexis Gonzalez Macias on 7/13/15.
//  Copyright (c) 2015 PropiedadFacil. All rights reserved.
//

import Foundation
import UIKit

class ParseClient: NSObject {
    
    var appID : String
    var apiKey : String
    let baseURL : String
    var session: NSURLSession
    var family : [User]
    
    override init() {
        self.appID = "jGifAB0fCsvuqQZg4TkeBVZJLBXrHqNEv9HEPAQ6"
        self.apiKey = "s5HWiUG5HJ7gfxmEKargbJWF58ipiVfaBF49q5tf"
        self.baseURL = "https://api.parse.com/1"
        self.session = NSURLSession.sharedSession()
        self.family = []
        super.init()
    }
    
    
    
    func storeData(data:[[String:AnyObject]]){
        self.family = []
        for userHash in data{
            self.family.append(User(data: userHash))
        }
    }
    

    func login(userData:[String:AnyObject],completionHandler: (success: Bool ,data: [String:AnyObject]?) -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let request = NSMutableURLRequest(URL: NSURL(string: "\(self.baseURL)/users?username=\(userData["username"])&password=\(userData["password"])")!)
        request.addValue("\(self.appID)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(self.apiKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if error != nil {
                completionHandler(success: false, data: ["error": "\(error!.localizedDescription)"])
                return
            }else{
                var parsedData:[String:AnyObject]?
                do{
                    parsedData = try  NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? [String:AnyObject]
                    completionHandler(success: true, data: parsedData! )
                }catch _{
                    completionHandler(success: false, data: nil )
                }
            }
            
        }
        task.resume()
    }

    
    
    // getting every user because lulz
    func getUsers(completionHandler: (success: Bool ,data: [String:AnyObject]?) -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let request = NSMutableURLRequest(URL: NSURL(string: "\(self.baseURL)/users")!)
        request.addValue("\(self.appID)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(self.apiKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if error != nil {
                completionHandler(success: false, data: ["error": "\(error!.localizedDescription)"])
                return
            }else{
                var parsedData:[String:AnyObject]?
                do{
                    parsedData = try  NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? [String:AnyObject]
                    completionHandler(success: true, data: parsedData! )
                }catch _{
                    completionHandler(success: false, data: nil )
                }
            }
            
        }
        task.resume()
    }
    
    func signUp(userInfo : [String:AnyObject], completionHandler:(success:Bool, data:[String:AnyObject]?) ->Void){
        let request = NSMutableURLRequest(URL: NSURL(string: "\(self.baseURL)/users")!)
        request.HTTPMethod = "POST"
        request.addValue("\(self.appID)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(self.apiKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let bodyString = "{\"username\":\"\(userInfo["name"]!)\",\"password\":\"\(userInfo["password"]!)\",\"email\":\"\(userInfo["email"]!)\"}"
        let body = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = body
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, data: ["ErrorString":error!.localizedDescription])
            }
            else{
                var jsonData : [String:AnyObject]?
                do{
                    jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? [String:AnyObject]
                    completionHandler(success: true, data : jsonData!)
                } catch _{
                    completionHandler(success: false, data : nil)
                }
                
            }
        }
        task.resume()
    }
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
}