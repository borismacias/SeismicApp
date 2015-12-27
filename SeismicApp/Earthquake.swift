//
//  Earthquake.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/19/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import Foundation
import MapKit

class Earthquake{
    
    var magnitude:Double!
    var description:String!
    var lat: CLLocationDegrees = 0.0
    var lng: CLLocationDegrees = 0.0
    var date: NSDate!
    
    init(dict: [String:AnyObject]){

        let data = dict["properties"]!
        let geometry = dict["geometry"] as! [String:AnyObject]
        let coordinates = geometry["coordinates"] as! NSArray
        
        let epocTime = NSTimeInterval( (data["time"]! as! Double)/1000 )
        self.magnitude = data["mag"] as! Double
        self.description = (data["place"] as! String).stringByReplacingOccurrencesOfString(", Chile", withString: "")
        self.lat = CLLocationDegrees(coordinates[0] as! Double)
        self.lng = CLLocationDegrees(coordinates[1] as! Double)
        self.date = NSDate(timeIntervalSince1970:  epocTime)
        
    }
    
}
