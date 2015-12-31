//
//  HomeTableViewController.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/19/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    @IBAction func logout(){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        //Deleting the logged in user's id
        defaults.setObject(nil, forKey:"objectId")
        defaults.synchronize()
        //Prompt the user to log back in
        self.performSegueWithIdentifier("showLogin", sender: self)
        
    }
    
    @IBAction func unwindFromSignIn(unwindSegue:UIStoryboardSegue){
    }
    
    @IBAction func unwindFromSignUp(unwindSegue:UIStoryboardSegue){
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = NSUserDefaults.standardUserDefaults()
        let userIDKey = "objectId"
        let storedID = defaults.stringForKey(userIDKey)
        //If there is no user logged in, show the login modal
        if storedID == nil  {
            self.performSegueWithIdentifier("showLogin", sender: self)
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

}
