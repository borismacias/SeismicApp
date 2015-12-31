//
//  DeckManagerTableViewController.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/28/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import UIKit
import CoreData

class DeckManagerTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    var decks:[Deck] = []
    @IBOutlet var button:UIButton!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Deck")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
    var sharedContext: NSManagedObjectContext {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.button.center = self.tableView.center
        self.tableView.addSubview(self.button)
        self.button.addTarget(self, action: "showNewDeckView", forControlEvents: .TouchUpInside)
        
        //Removing separators for empty tablecells
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        //Removing small left margin in the table separator insets
        self.tableView.separatorInset = UIEdgeInsetsZero
        
        super.viewDidLoad()
       
        
        self.fetchedResultsController.delegate = self

    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        self.decks = []
        //Getting every question created
        self.updateData()
    }
    
    func showNewDeckView(){
        self.tabBarController?.selectedIndex = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.decks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DeckCell", forIndexPath: indexPath)
        let deck = self.decks[indexPath.row]
        cell.textLabel?.text = deck.name
        //Removing small left margin in the table separator insets
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showDeck", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDeck" {
            let destinationVC = segue.destinationViewController as! ShowDeckTableViewController
            if let indexPath = self.tableView.indexPathForSelectedRow{
                destinationVC.deck = self.decks[indexPath.row]
            }
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Borrar",handler: { (action, indexPath) -> Void in
            
            // Delete the row from the database
                
            let deckTodelete = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Deck
            self.sharedContext.deleteObject(deckTodelete)
            print("trying to delete")
            do {
                try self.sharedContext.save()
                self.updateData()
                Helpers.displayAlert("Exito", message: "El mazo ha sido borrado", vc: self)
                
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
        self.decks = self.fetchedResultsController.fetchedObjects! as! [Deck]
        
        if(self.decks.count != 0){
            self.button.hidden = true
        }else{
            self.button.hidden = false
        }
        
        self.tableView.reloadData()

    }
    
}
