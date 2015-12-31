//
//  QuizManagerTableViewController.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/27/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import UIKit
import CoreData

class QuizManagerTableViewController: UITableViewController,NSFetchedResultsControllerDelegate {
    
    var quizzes:[Quiz] = []
    var fetchResultController:NSFetchedResultsController!
    @IBOutlet var button:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.button.center = self.tableView.center
        self.tableView.addSubview(self.button)
        self.button.addTarget(self, action: "goToNew", forControlEvents: .TouchUpInside)
        
        //Removing separators for empty tablecells
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        //Removing small left margin in the table separator insets
        self.tableView.separatorInset = UIEdgeInsetsZero
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        //Getting every question created
        let fetchRequest = NSFetchRequest(entityName: "Quiz")
        let sortDescriptor = NSSortDescriptor(key: "level", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                self.quizzes = fetchResultController.fetchedObjects as! [Quiz]
                if(self.quizzes.count != 0){
                    self.tableView.reloadData()
                    self.button.hidden = true
                }else{
                    self.button.hidden = false
                }
                
            } catch {
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return quizzes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("QuizCell", forIndexPath: indexPath)
        let quiz = self.quizzes[indexPath.row]
        cell.textLabel?.text = quiz.question
        //Removing small left margin in the table separator insets
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    func goToNew(){
        self.tabBarController?.selectedIndex = 1
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Showing the question in a new view
        self.performSegueWithIdentifier("showQuestion", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController as! ShowQuizViewController
        if segue.identifier == "showQuestion" {
            if let indexPath = self.tableView.indexPathForSelectedRow{
                destinationVC.quiz = self.quizzes[indexPath.row]
            }
        }
    }

}
