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
    
    @IBAction func signUp(){
    
        let name = nameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if(name?.characters.count == 0||email?.characters.count == 0||password?.characters.count == 0){
            let alertViewController = UIAlertController.init(title: "Missing Fields", message: "You need to type in your name, email AND a password", preferredStyle: UIAlertControllerStyle.Alert)
            let dismissAction = UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            alertViewController.addAction(dismissAction)
            self.presentViewController(alertViewController, animated: true, completion: nil)
        }else{
            let userInfo = [
                "name": name!,
                "email": email!,
                "password": password!
            ]
            ParseClient.sharedInstance().signUp(userInfo, completionHandler: {
                (success,data) -> Void in
                
                dispatch_async(dispatch_get_main_queue(),{
                    let title:String!
                    let message:String!
                    print(data)
                    if success{
                        if data!["error"] != nil{
                            title = "Error"
                            message = data!["error"] as! String
                        }else{
                            title = "Success"
                            message = "Account Created"
                            NSUserDefaults.standardUserDefaults().setObject(data!["objectId"], forKey: "objectId")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                    }else{
                        title = "Error"
                        message = "Unexpected Error"
                    }
                    
                    let alertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    let alertAction = UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(alertAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
