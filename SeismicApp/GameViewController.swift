//
//  GameViewController.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/30/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import UIKit
import CoreData

class GameViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var deck:Deck!
    
    @IBOutlet var deckName:UILabel!
    
    var fetchResultController:NSFetchedResultsController!
    
    //Storing and sorting the flashcards by level using a simplification of the Leitner System
    //https://en.wikipedia.org/wiki/Leitner_system
    var flashcards:[[Flashcard]] = [[],[],[],[]]
    
    //Blur effect for the unwind segue between flashcards
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.deckName.text = self.deck.name
        self.fetchFlashcards(1)
        self.fetchFlashcards(2)
        self.fetchFlashcards(3)
    }
    
    //Unwind after asking for a new flashcard
    @IBAction func unwindFromFlashcardsNext(segue:UIStoryboardSegue){
        
        //BLurring the background before showing the next flashcard
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        //Wait and then show the modal with the next flashcard
        dispatch_after(1, dispatch_get_main_queue()) { () -> Void in
            self.performSegueWithIdentifier("showFlashcard", sender: self)
        }
    }
    
    //Unwind after finishing the flashcard sequence by clicking the Ok button between rounds
    @IBAction func unwindFromFlashcardsDone(segue:UIStoryboardSegue){
        
        //Removing the background blur effect (because there wont be more flashcards to be shown)
        self.blurEffectView.removeFromSuperview()
        
        //Wait and show an alert view prompting to add more flashcards
        dispatch_after(1, dispatch_get_main_queue()) { () -> Void in
            let alertcontroller = UIAlertController.init(title: "Fin", message: "Si han sido muy pocas tarjetas, intenta creando más", preferredStyle: .Alert)
            let okAction = UIAlertAction.init(title: "Ok", style: .Default, handler: nil)
            alertcontroller.addAction(okAction)
            self.presentViewController(alertcontroller, animated: true, completion: nil)
        }
    }
    
    func fetchFlashcards(level:Int){
        
        let fetchRequest = NSFetchRequest(entityName: "Flashcard")
        let sortDescriptor = NSSortDescriptor(key: "level", ascending: true)
        //Getting only the quizzes that match the level
        let predicate = NSPredicate( format: "level = %@ AND deck = %@", argumentArray:[level,self.deck] )
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                //Storing in the "level box" the results
                self.flashcards[level] = fetchResultController.fetchedObjects as! [Flashcard]
            } catch {
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showFlashcard"{
            let destinationVC = segue.destinationViewController as! FlashcardViewController
            destinationVC.flashcard = self.nextFlashcard()
        }
        if segue.identifier == "unwindToAddMoreFlashcards"{
            let destinationVC = segue.destinationViewController as! AddFlashcardViewController
            destinationVC.deck = self.deck
        }
    }
    
    @IBAction func showFlashcard(){
        self.performSegueWithIdentifier("showFlashcard", sender: self)
    }
    
    func nextFlashcard() -> Flashcard {
        
        //Get a random number from 0 to 9
        let random = Int(arc4random_uniform(10))

        //We pick a flashcard from a random box. Each box will have a different probability of being chosen depending on the level of the questions stored there
        
        //7 out of 10 70% chance. Lvl 1 flashcards
        if(random >= 0 && random < 7){
            
            return self.nextFlashcard(1)
            
            //2 out of 10 20% chance. Lvl 2 flashcards
        }else if(random >= 7 && random < 9){
            
            return self.nextFlashcard(2)
            
            //1 out of 10 10% chance. Lvl 3 quizzes
        }else{
            
            return self.nextFlashcard(3)
            
        }
        
    }
    
    func nextFlashcard(level: Int) -> Flashcard {
        
        //If there are no flashcards in the required level box
        if self.flashcards[level].isEmpty {
            //Check if we are asking for level 3 flashcards
            if(level == 3){
                //If we do, return a flashcard from the level 1
                return nextFlashcard(1)
            }
            //Else return a flashcard from the next level box
            return nextFlashcard(level + 1)
        }
        
        //If there were flashcards in the required level box, we pick one at random
        let random = Int(arc4random_uniform( UInt32(self.flashcards[level].count) ) )
        let flashArray = self.flashcards[level]
        
        return flashArray[random]
    }


}
