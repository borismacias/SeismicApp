//
//  AddDeckViewController.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/28/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import UIKit
import CoreData

class AddDeckViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var nameTextfield:UITextField!
    
    var sharedContext: NSManagedObjectContext {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextfield.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reset(){
        self.nameTextfield.text = ""
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func save(){
        
        let name = nameTextfield.text
        
        if name != "" {

                let _ = Deck(name: name!, context: self.sharedContext)
            
                let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                delegate.saveContext()
                self.reset() //Resetting to initial state
            
        }else{
            //Showing alert and prompting if the user wants to discard the changes or fix the submission
            let alertController = UIAlertController.init(title: "Error", message: "Por favor completa todos los campos.", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(action)
            let goHomeAction = UIAlertAction.init(title: "Ir a la lista de Flashcards", style: .Destructive, handler: { (action:UIAlertAction) in
                self.reset()
            } )
            alertController.addAction(goHomeAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
