//
//  Helpers.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/20/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import UIKit

class Helpers{

    class func displayAlert(title:String!, message:String!, vc:UIViewController){
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction.init(title: "Done", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(alertAction)
        vc.presentViewController(alertController, animated: true, completion: nil)
    }
    
}