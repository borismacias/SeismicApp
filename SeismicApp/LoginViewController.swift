//
//  LoginViewController.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/19/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailInput:UITextField!
    @IBOutlet var passwordInput:UITextField!
    
    @IBAction func login(){
        let email = emailInput.text
        let password = passwordInput.text
        if(email?.characters.count == 0 || password?.characters.count == 0){
            let alertController = UIAlertController.init(title: "Missing Fields", message: "You need to type in your email AND your password", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.Default,handler: nil)
            
            alertController.addAction(alertAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            
            let userData = [
                "email": email!
            ]
            ParseClient.sharedInstance().login(userData,completionHandler: {
                (success, data) -> Void in
                    print(success)
                    print(data)
            })
            print("Email: \(email)")
            print("Password: \(password)")
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailInput.delegate = self
        self.passwordInput.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
