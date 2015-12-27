//
//  User.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/19/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import Foundation

class User{

    var username:String!
    var email:String!
    var objectId:String!
    
    init(data: [String:AnyObject]){
        self.objectId = data["id"] as! String
        self.username = data["name"] as! String
        self.email = data["email"] as! String
    }
    
}
