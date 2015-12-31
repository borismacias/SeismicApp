//
//  AnswerViewController.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/30/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {
    
    var flashcard:Flashcard!
    
    @IBOutlet var flashcardImage:UIImageView!
    @IBOutlet var answerField:UITextView!
    
    @IBAction func mal(){
        flashcard.level = 1
        whatNext()
    }
    
    @IBAction func bien(){
        flashcard.level = 2
        whatNext()
    }
    
    @IBAction func muyBien(){
        flashcard.level = 3
        whatNext()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.flashcardImage.image = flashcard.getImage()
        self.answerField.text = flashcard.definition
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func whatNext(){
        let alert = UIAlertController.init(title: "¿Quieres continuar?", message: nil, preferredStyle: .Alert)
        let nextAction = UIAlertAction.init(title: "Si", style: .Default, handler: {(alert:UIAlertAction)->Void in
            self.performSegueWithIdentifier("unwindFromFlashcardsNext", sender: self)
        })
        let doneAction = UIAlertAction.init(title: "No", style: .Destructive, handler: {(alert:UIAlertAction)->Void in
            self.performSegueWithIdentifier("unwindFromFlashcardsDone", sender: self)
        })
        alert.addAction(nextAction)
        alert.addAction(doneAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
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
