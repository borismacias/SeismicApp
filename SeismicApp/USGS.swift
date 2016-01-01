//
//  USGS.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/26/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import Foundation
import UIKit

class USGS: NSObject {
    
    let baseURL : String
    var session: NSURLSession
    var earthquakes : [Earthquake]
    
    override init() {
        self.earthquakes = []
        self.baseURL = "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary"
        self.session = NSURLSession.sharedSession()
        super.init()
    }
    
    
    func storeData(data:[[String:AnyObject]]){
        self.earthquakes = []
        for earthquakeHash in data{
            self.earthquakes.append(Earthquake(dict: earthquakeHash))
        }
    }
    
    
    func getData(completionHandler: (success: Bool ,data: [String:AnyObject]?) -> Void) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let url = "\(self.baseURL)/all_day.geojson"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)

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
                    let metadata = parsedData!["metadata"] as! [String:AnyObject]
                    let status = metadata["status"] as! Int
                    if status != 200{
                        //If there was an api error, we send only the metadata - error cause to the handler
                        completionHandler(success: false, data: metadata)
                    }else{
                        var data = [String:AnyObject]()
                        let features = parsedData!["features"] as! [[String:AnyObject]]
                        let filtered = features.filter { feature in
                            let properties = feature["properties"] as! [String:AnyObject]
                            let place = properties["place"] as! String
                            //Filtering. Using only chilean earthquakes
                            //return place.rangeOfString(", Chile") != nil
                            return true
                        }
                        self.storeData(filtered)
                        data["earthquakes"] = self.earthquakes
                        completionHandler(success: true, data: data )
                    }
                    
                }catch _{
                    completionHandler(success: false, data: nil )
                }
            }
            
        }
        task.resume()
    }
    

    class func sharedInstance() -> USGS {
        
        struct Singleton {
            static var sharedInstance = USGS()
        }
        
        return Singleton.sharedInstance
    }
}