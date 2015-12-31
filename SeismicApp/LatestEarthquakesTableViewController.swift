//
//  LatestEarthquakesTableViewController.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/26/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import UIKit

class LatestEarthquakesTableViewController: UITableViewController {

    var earthquakes:[Earthquake] = []
    @IBOutlet var tableview:UITableView!
    var spinner:UIActivityIndicatorView!
    @IBOutlet var noEarthquakesLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting up a spinner
        spinner = UIActivityIndicatorView()
        spinner.activityIndicatorViewStyle = .Gray
        spinner.center = view.center
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        spinner.startAnimating()
        
        self.noEarthquakesLabel.hidden = true
        self.noEarthquakesLabel.center = self.view.center
        self.view.addSubview(self.noEarthquakesLabel)
        
        //Control to refresh the table's information on swipe down
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.whiteColor()
        refreshControl?.tintColor = UIColor.grayColor()
        refreshControl?.addTarget(self, action: "getEarthquakes", forControlEvents: UIControlEvents.ValueChanged)
        
        //Get latest earthquake data
        USGS.sharedInstance().getData( {(success,data) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if(success){
                    self.earthquakes = data!["earthquakes"] as! [Earthquake]
                    if self.earthquakes.count == 0 {
                        self.noEarthquakesLabel.hidden = false
                    }
                    else{
                        self.noEarthquakesLabel.hidden = true
                    }
                    self.tableView.reloadData()
                }else{
                    Helpers.displayAlert("Error", message: "Hubo un error en la red. Reinicia la aplicación e inténtalo nuevamente.", vc: self)
                }
                self.spinner.stopAnimating()
            })
        })
        
        //Deleting unused cells and left margin on separator insets
        self.tableview.separatorInset = UIEdgeInsetsZero
        self.tableview.tableFooterView = UIView(frame: CGRectZero)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.earthquakes.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EarthquakeCell", forIndexPath: indexPath) as! LatestEarthquakeTableViewCell
        let earthquake = self.earthquakes[indexPath.row]
        
        //Adding cell info
        cell.magnitudeLabel?.text = "\(earthquake.magnitude)"
        cell.placeLabel?.text = earthquake.description

        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let dateString = formatter.stringFromDate(earthquake.date)
        cell.dateLabel?.text = dateString

        //Deleting left inset margin
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("detailEarthquakeSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailEarthquakeSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let destinationController = segue.destinationViewController as! EarthquakeDetailViewController
                destinationController.earthquake = self.earthquakes[indexPath.row]
            }
        }
    }
    
    func getEarthquakes(){
        // Remove existing records before refreshing
        self.earthquakes.removeAll()
        self.tableView.reloadData()
        
        USGS.sharedInstance().getData( {(success,data) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if(success){
                    self.earthquakes = data!["earthquakes"] as! [Earthquake]
                    self.tableView.reloadData()
                    if self.earthquakes.count == 0 {
                        self.noEarthquakesLabel.hidden = false
                    }
                    else{
                        self.noEarthquakesLabel.hidden = true
                    }
                }else{
                    Helpers.displayAlert("Error", message: "Hubo un error en la red. Reinicia la aplicación e inténtalo nuevamente.", vc: self)
                }
                self.refreshControl?.endRefreshing()
            })
        })

    }
}
