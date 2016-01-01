//
//  LoginViewController.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/19/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var usernameInput:UITextField!
    @IBOutlet var passwordInput:UITextField!
    var spinner:UIActivityIndicatorView!
    
    @IBAction func login(){
        
        //Showing the spinner after submitting the credentials to log in
        spinner = UIActivityIndicatorView()
        spinner.activityIndicatorViewStyle = .Gray
        spinner.center = view.center
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        spinner.startAnimating()
        
        let username = usernameInput.text
        let password = passwordInput.text
        
        //Checking if the user filled both fields
        if(username?.characters.count == 0 || password?.characters.count == 0){
            let alertController = UIAlertController.init(title: "Error", message: "Debes ingresar tu nombre de usuario Y tu contraseña", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.Default,handler: nil)
            
            alertController.addAction(alertAction)
            spinner.stopAnimating()
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            
            let userData = [
                "username": username!,
                "password": password!
            ]
            //Signing in through Parse API
            ParseClient.sharedInstance().signIn(userData,completionHandler: {
                (success, data) -> Void in
                dispatch_async(dispatch_get_main_queue(),{
                    let title:String!
                    let message:String!
                    if success{
                        if data!["error"] != nil{
                            title = "Error"
                            message = data!["error"] as! String
                            Helpers.displayAlert(title, message: message, vc: self)
                        }else{
                            title = "Exito"
                            message = "Conectado"
                            //Storing the logged in user id
                            NSUserDefaults.standardUserDefaults().setObject(data!["objectId"], forKey: "objectId")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            self.performSegueWithIdentifier("unwindFromSignIn", sender: self)
                        }
                    }else{
                        title = "Error"
                        message = "\(data!["error"]!)"
                        Helpers.displayAlert(title, message: message, vc: self)
                    }
                    self.spinner.stopAnimating()
                })
            })
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameInput.delegate = self
        self.passwordInput.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //End editing after hitting the return key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
