//
//  NewFlashcardViewController.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/27/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import UIKit

class NewFlashcardViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var questionField:UITextField!
    @IBOutlet var correctAnswerField:UITextField!
    @IBOutlet var failedAnswer1:UITextField!
    @IBOutlet var failedAnswer2:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.questionField.delegate = self
        self.correctAnswerField.delegate = self
        self.failedAnswer2.delegate = self
        self.failedAnswer1.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel() {
        
            self.questionField.text = ""
            self.correctAnswerField.text = ""
            self.failedAnswer1.text = ""
            self.failedAnswer2.text = ""
            self.tabBarController?.selectedIndex = 0
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
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
