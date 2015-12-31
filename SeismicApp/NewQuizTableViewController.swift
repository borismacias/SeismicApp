//
//  NewQuizTableViewController.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/27/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import UIKit
import CoreData

class NewQuizTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var questionField:UITextField!
    @IBOutlet var correctAnswerField:UITextField!
    @IBOutlet var failedAnswerField1:UITextField!
    @IBOutlet var failedAnswerField2:UITextField!
    
    @IBAction func unwindFromNoQuizAdded(segue: UIStoryboardSegue){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.questionField.delegate = self
        self.correctAnswerField.delegate = self
        self.failedAnswerField2.delegate = self
        self.failedAnswerField1.delegate = self
        //Extending the view to show the bottom of the table (tested on iphone 5)
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.questionField.becomeFirstResponder()
    }
    
    @IBAction func reset() {
        
        //Resetting to initial state
        self.questionField.text = ""
        self.correctAnswerField.text = ""
        self.failedAnswerField1.text = ""
        self.failedAnswerField2.text = ""
        
        //Showing the manage tab
        self.tabBarController?.selectedIndex = 0
        
    }
    
    @IBAction func save() {
    
        let question = self.questionField.text!
        let correctAnswer = self.correctAnswerField.text!
        let failedAnswer1 = self.failedAnswerField1.text!
        let failedAnswer2 = self.failedAnswerField2.text!
        
        //Checking if all the fields are filled
        if( (question != "" ) && (correctAnswer != "") && (failedAnswer1 != "") && (failedAnswer2 != "") ){
            
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                let quiz = NSEntityDescription.insertNewObjectForEntityForName("Quiz", inManagedObjectContext: managedObjectContext) as! Quiz
                quiz.correctAnswer = correctAnswer
                quiz.question = question
                quiz.failedAnswer1 = failedAnswer1
                quiz.failedAnswer2 = failedAnswer2
                quiz.level = 1
                
                do {
                    try managedObjectContext.save()
                    self.reset() //Resetting to initial state
                } catch {
                    print(error)
                    return
                }
            }
            
        }else{
            //Showing alert and prompting if the user wants to discard the changes or fix the submission
            let alertController = UIAlertController.init(title: "Error", message: "Por favor completa todos los campos.", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(action)
            let goHomeAction = UIAlertAction.init(title: "Ir a la lista de preguntas", style: .Destructive, handler: { (action:UIAlertAction) in
                self.reset()
                self.tabBarController?.selectedIndex = 0
            } )
            alertController.addAction(goHomeAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    
    //End editing after hitting return key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    //End editing after touching outside the keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event!)
    }

}
