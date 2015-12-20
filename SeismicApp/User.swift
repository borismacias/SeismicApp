//
//  User.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/19/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import Foundation

class User{

    var name:String!
    var email:String!
    var id:String!
    
    init(data: [String:AnyObject]){
        self.id = data["id"] as! String
        self.name = data["name"] as! String
        self.email = data["email"] as! String
    }
    
}
