//
//  SignUpViewController.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/19/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var nameTextField:UITextField!
    @IBOutlet var emailTextField:UITextField!
    @IBOutlet var passwordTextField:UITextField!
    var spinner:UIActivityIndicatorView!
    
    @IBAction func signUp(){
        
        //Setting up and adding a spinner
        spinner = UIActivityIndicatorView()
        spinner.activityIndicatorViewStyle = .Gray
        spinner.center = view.center
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        spinner.startAnimating()
        
        let name = nameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        
        //Checking if all the fields have been filled
        if(name?.characters.count == 0||email?.characters.count == 0||password?.characters.count == 0){
            let alertViewController = UIAlertController.init(title: "Error", message: "Debes escribir tu nombre de usuario, email Y contraseña", preferredStyle: UIAlertControllerStyle.Alert)
            let dismissAction = UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            alertViewController.addAction(dismissAction)
            self.presentViewController(alertViewController, animated: true, completion: nil)
        }else{
            let userInfo = [
                "name": name!,
                "email": email!,
                "password": password!
            ]
            //Executing parse signup function
            ParseClient.sharedInstance().signUp(userInfo, completionHandler: {
                (success,data) -> Void in
                
                dispatch_async(dispatch_get_main_queue(),{
                    let title:String!
                    let message:String!
                    if success{
                        if data!["error"] != nil{
                            title = "Error"
                            message = data!["error"] as! String
                            Helpers.displayAlert(title, message: message, vc: self)
                        }else{
                            //Storing the user id from parse signup
                            NSUserDefaults.standardUserDefaults().setObject(data!["objectId"], forKey: "objectId")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            
                            self.performSegueWithIdentifier("unwindFromSignUp", sender: self)
                        }
                    }else{
                        title = "Error"
                        message = "Unexpected Error"
                        Helpers.displayAlert(title, message: message, vc: self)
                    }
                    self.spinner.stopAnimating()
                })
                
            })
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //End edit after hitting the return key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false;
    }

}
