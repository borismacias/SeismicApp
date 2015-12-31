//
//  ShowDeckTableViewController.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/28/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import UIKit
import CoreData

class ShowDeckTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var deck:Deck!
    var flashcards:[Flashcard] = []
    var sharedContext: NSManagedObjectContext {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Flashcard")
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "deck == %@", self.deck)
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    //Unwind after asking for a new question
    @IBAction func unwindFromAdd(segue:UIStoryboardSegue){
        dispatch_after(1, dispatch_get_main_queue()) { () -> Void in
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchedResultsController.delegate = self
        
        //Removing separators for empty tablecells
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        //Removing small left margin in the table separator insets
        self.tableView.separatorInset = UIEdgeInsetsZero
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.flashcards.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("flashcardCell", forIndexPath: indexPath) as! FlashcardTableViewCell
        let flashcard = self.flashcards[indexPath.row]
        cell.name.text = flashcard.name
        cell.flashcardImage.image = flashcard.getImage()
        cell.flashcardImage.layer.cornerRadius = 42
        cell.flashcardImage.clipsToBounds = true
        //Removing small left margin in the table separator insets
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Borrar",handler: { (action, indexPath) -> Void in
            
            // Delete the row from the database
            
            let flashTodelete = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Flashcard
            self.sharedContext.deleteObject(flashTodelete)

            do {
                try self.sharedContext.save()
                self.updateData()
                Helpers.displayAlert("Exito", message: "La Flashcard ha sido borrada", vc: self)
                
            } catch {
                print(error)
            }
            
        })
        
        deleteAction.backgroundColor = UIColor.redColor()
        
        return [deleteAction]
        
    }
    
    func updateData(){
        do{
            try self.fetchedResultsController.performFetch()
        }catch {}
        self.flashcards = self.fetchedResultsController.fetchedObjects! as! [Flashcard]
        
        self.tableView.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("flashcardDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addFlashcard" {
            let destinationVC = segue.destinationViewController as! AddFlashcardViewController
            destinationVC.deck = self.deck
        }
        if segue.identifier == "flashcardDetail" {
            let destinationVC = segue.destinationViewController as! FlashcardDetailViewController
            if let indexPath = self.tableView.indexPathForSelectedRow{
                destinationVC.flashcard = self.flashcards[indexPath.row]
            }
        }
    }

}
