//
//  AddFlashcardViewController.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/28/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import UIKit
import CoreData

class AddFlashcardViewController: UITableViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate{

    var deck:Deck!
    
    var sharedContext: NSManagedObjectContext {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }
    
    @IBOutlet var nameTextfield:UITextField!
    @IBOutlet var imageView:UIImageView!
    @IBOutlet var definitionTextField:UITextView!
    @IBOutlet var defaultTopConstraint:NSLayoutConstraint!

    
    //New constraints after the image has been picked
    var pickedleadingConstraint:NSLayoutConstraint?
    var pickedtopConstraint:NSLayoutConstraint?
    var pickedbottomConstraint:NSLayoutConstraint?
    var pickedtrailingConstraint:NSLayoutConstraint?
    
    var imageName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameTextfield.delegate = self
        self.definitionTextField.delegate = self
        //Setting up the placeholder on the uitextview
        self.definitionTextField.text = "Ingresa la definición de tu Flashcard"
        self.definitionTextField.textColor = UIColor.lightGrayColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    @IBAction func unwindToAddMoreFlashcards(segue:UIStoryboardSegue){
        print("asd")
    }
    
    //Imagepicker related functions
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .PhotoLibrary
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        
        pickedleadingConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: imageView.superview, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        pickedleadingConstraint!.active = true
        
        pickedtrailingConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: imageView.superview, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        pickedtrailingConstraint!.active = true
        
        pickedtopConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: imageView.superview, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        pickedtopConstraint!.active = true
        
        defaultTopConstraint.active = false
        
        let bottomConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: imageView.superview, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        bottomConstraint.active = true
        
        self.imageName = "temp_\(NSDate().timeIntervalSince1970)"
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Enabling top constraint after canceling image pick - Deleting image preview after cancel
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.imageView.image = UIImage.init(named: "pick")
        self.defaultTopConstraint.active = true
        
        //disabling picked image constraints because cancel action
        self.pickedleadingConstraint?.active = false
        self.pickedtrailingConstraint?.active = false
        self.pickedtopConstraint?.active = false
        self.pickedbottomConstraint?.active = false
        
        self.imageName = nil
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func reset(){
        self.nameTextfield.text = nil
        self.imageView.image = UIImage(named: "picker")
        self.definitionTextField.text = nil
        self.performSegueWithIdentifier("unwindFromAddFlashcard", sender: self)
    }
    
    @IBAction func save(){

        let name = nameTextfield.text!
        let image = imageView.image!
        let definition = definitionTextField.text
        
        if name != "" && self.imageName != nil && definition != nil && definition != "" {

            _ = Flashcard(name: name, definition: definition, deck: self.deck, imageName: self.imageName!, image:image, context: self.sharedContext)
                
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            delegate.saveContext()
            self.reset()

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
   
    //Definition field delegate methods
    //Deleting the uitextview placeholder
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    //Hiding the keyboard on return
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //If the user didint input anything before returning, we will recreate the placeholder
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == nil||textView.text == "" {
            textView.textColor = UIColor.lightGrayColor()
            textView.text = "Ingresa la definición de tu Flashcard"
        }
        
    }


}
