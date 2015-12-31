//
//  QuizViewController.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/28/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import UIKit

//To randomize the alternatives
import GameKit

class QuizViewController: UIViewController {
    
    var quiz:Quiz?
    var correct = false
    
    @IBOutlet var questionLabel:UILabel!
    @IBOutlet var button1:UIButton!
    @IBOutlet var button2:UIButton!
    @IBOutlet var button3:UIButton!
    @IBOutlet var stackView:UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        //If the quiz sent is nil, it means that there are no quizzes added. We show an alert informing the user about this
        if(quiz == nil){
            let alertController = UIAlertController(title: "Error", message: "Debes agregar preguntas antes de jugar", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction.init(title: "Agregar", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction)-> Void in
                //Unwind to the add quiz view
                self.performSegueWithIdentifier("unwindFromNoQuizAdded", sender: self)
            })
            alertController.addAction(alertAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            
            questionLabel.text = self.quiz!.question
            
            //Shuffle the alternatives to this quiz question
            let alternatives = self.randomizeAlternatives(self.quiz!.getAlternatives())
            
            //Then we configure each UIButton, adding the titile and the action
            self.setupButton(alternatives[0], button: button1)
            self.setupButton(alternatives[1], button: button2)
            self.setupButton(alternatives[2], button: button3)
            
            //We show the question and the alternatives
            self.stackView.hidden = false
            self.questionLabel.hidden = false
        }
    }
    
    func randomizeAlternatives(alternativeDicts:[[String:AnyObject]])->[[String:AnyObject]]{
        //Shuffling the alternatives dictionaries and returning them shuffled
        return GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(alternativeDicts) as! [[String:AnyObject]]
    }
    
    func setupButton(alternativeDict:[String:AnyObject], button: UIButton){
        
        let title = alternativeDict["answer"] as! String
        //Setting the button's title
        button.setTitle(title, forState: UIControlState.Normal)

        //Setting the button's action, depending on the alternative
        let correct = alternativeDict["correct"] as! Bool
        let buttonAction = (correct ?  "correctAnswer" : "wrongAnswer")
        button.addTarget(self, action: Selector(buttonAction), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func correctAnswer(){
        //Setting up the state before showing the new question(quiz)
        self.correct = true
        showFeedback("Correcto")
    }
    
    func wrongAnswer(){
        showFeedback("Error")
    }
    
    func showFeedback(title:String!){
        let alertVC = UIAlertController.init(title: title, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let nextAction = UIAlertAction.init(title: "Siguiente", style: UIAlertActionStyle.Default, handler: {(alert:UIAlertAction) -> Void in
            self.performSegueWithIdentifier("unwindFromNext", sender: self)
        })
        let doneAction = UIAlertAction.init(title: "Parar", style: UIAlertActionStyle.Destructive, handler: {(alert:UIAlertAction)-> Void in
            self.performSegueWithIdentifier("unwindFromDone", sender: self)
        })
        alertVC.addAction(nextAction)
        alertVC.addAction(doneAction)
        self.presentViewController(alertVC, animated: true, completion: nil)
    }

}
