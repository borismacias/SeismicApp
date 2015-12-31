//
//  PlayQuizViewController.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/27/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import UIKit
import CoreData

class PlayQuizViewController: UIViewController,NSFetchedResultsControllerDelegate {

    var fetchResultController:NSFetchedResultsController!
    
    //Storing and sorting the quizzes by level using a simplification of the Leitner System
    //https://en.wikipedia.org/wiki/Leitner_system
    var quizzes:[[Quiz]] = [[],[],[],[]]
    
    //Blur effect for the unwind segue between questions
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchQuizzes(1)
        self.fetchQuizzes(2)
        self.fetchQuizzes(3)
    }
    
    //Unwind after asking for a new question
    @IBAction func unwindFromNext(segue:UIStoryboardSegue){
        
        //BLurring the background before showing the next question
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        let sourceVC = segue.sourceViewController as! QuizViewController
        let correct = sourceVC.correct
        let quiz = sourceVC.quiz!
        let level = (quiz.level).intValue
       
        //Updating the difficulty level of the question(quiz)
        //https://en.wikipedia.org/wiki/Leitner_system
        
        if correct{
            
            //The level 3 is the max level (well known/ has answered it correctly at least 2 times in a row)
            if level != 3 {
                quiz.level = NSNumber(int: level + 1)
            }
        }
        else{
            
            //The level 1 is the min level (not known/ hasn't answered it correctly before)
            if quiz.level != 1 {
                quiz.level = NSNumber(int: level - 1)
            }
        }
        
        //Wait and then show the modal with the next question
        dispatch_after(1, dispatch_get_main_queue()) { () -> Void in
            self.performSegueWithIdentifier("showQuiz", sender: self)
        }
    }
    
    //Unwind after finishing the quiz sequence by clicking the Ok button between rounds
    @IBAction func unwindFromDone(segue:UIStoryboardSegue){
        
        //Removing the background blur effect (because there wont be more questions to be shown)
        self.blurEffectView.removeFromSuperview()
        
        //Wait and show an alert view prompting to add more questions
        dispatch_after(1, dispatch_get_main_queue()) { () -> Void in
            let alertcontroller = UIAlertController.init(title: "Fin", message: "Si han sido muy pocas preguntas, intenta creando más", preferredStyle: .Alert)
            let addQuizAction = UIAlertAction.init(title: "Agregar preguntas", style: .Default, handler: {(alert:UIAlertAction) -> Void in
                //Switch to add quiz tab
                self.tabBarController?.selectedIndex = 1
            })
            let okAction = UIAlertAction.init(title: "Ok", style: .Default, handler: nil)
            alertcontroller.addAction(addQuizAction)
            alertcontroller.addAction(okAction)
            self.presentViewController(alertcontroller, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showQuiz" {
            let destinationVC = segue.destinationViewController as! QuizViewController
            destinationVC.quiz = nextQuiz()
        }
    }
  
    func fetchQuizzes(level:Int){
        
        let fetchRequest = NSFetchRequest(entityName: "Quiz")
        let sortDescriptor = NSSortDescriptor(key: "level", ascending: true)
        //Getting only the quizzes that match the level
        let predicate = NSPredicate( format: "level = %@", argumentArray:[level] )
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                //Storing in the "level box" the results
                self.quizzes[level] = fetchResultController.fetchedObjects as! [Quiz]
            } catch {
                print(error)
            }
        }
    }
    
    func nextQuiz() -> Quiz? {
        
        //If there are no quizzes, return nil. The view that will show the quiz will handle it
        if(self.quizzes[1].isEmpty && self.quizzes[2].isEmpty && self.quizzes[3].isEmpty){
            return nil
        }
        //Get a random number from 0 to 9
        let random = Int(arc4random_uniform(10))
        
        //We pick a quiz from a random box. Each box will have a different probability of being chosen depending on the level of the questions stored there

        //7 out of 10 70% chance. Lvl 1 quizzes, the ones that havent being answered correctly yet
        if(random >= 0 && random < 7){
        
            return self.nextQuiz(1)
        
        //2 out of 10 20% chance. Lvl 2 quizzes, the ones that have been answered correctly at least 1 time
        }else if(random >= 7 && random < 9){
            
            return self.nextQuiz(2)
        
        //1 out of 10 10% chance. Lvl 3 quizzes, the ones that have been answered correctly at least 2 times in a row
        }else{
            
            return self.nextQuiz(3)
            
        }
        
    }
    
    func nextQuiz(level: Int) -> Quiz {
        
        //If there are no quizzes in the required level box
        if self.quizzes[level].isEmpty {
            //Check if we are asking for level 3 quizzes
            if(level == 3){
                //If we do, return a quiz from the level 1
                return nextQuiz(1)
            }
            //Else return a quiz from the next level box
            return nextQuiz(level + 1)
        }
        
        //If there were quizzes in the required level box, we pick one at random
        let random = Int(arc4random_uniform( UInt32(self.quizzes[level].count) ) )
        let quizArray = self.quizzes[level]

        return quizArray[random] 
    }

}
