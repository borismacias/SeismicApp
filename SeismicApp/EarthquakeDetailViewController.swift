//
//  EarthquakeDetailViewController.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/26/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import UIKit
import MapKit

class EarthquakeDetailViewController: UIViewController,MKMapViewDelegate {
    
    var earthquake:Earthquake!
    @IBOutlet var mapview:MKMapView!
    @IBOutlet var placeLabel:UILabel!
    @IBOutlet var dateLabel:UILabel!
    
    @IBAction func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting up the mapview to show the earthqake's epicenter
        mapview.showsTraffic = true
        mapview.showsCompass = true
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let dateString = formatter.stringFromDate(earthquake.date)

        placeLabel.text = earthquake.description
        dateLabel.text = dateString
        
        // Add annotation
        let annotation = MKPointAnnotation()
        annotation.title = "\(self.earthquake.magnitude)"
        annotation.coordinate = CLLocationCoordinate2D.init(latitude: earthquake.lng, longitude: earthquake.lat)
        self.mapview.showAnnotations([annotation], animated: true)
        self.mapview.selectAnnotation(annotation, animated: true)
        
        //Customizing the zoom
        let span = MKCoordinateSpanMake(2, 2)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: earthquake.lng, longitude: earthquake.lat), span: span)
        
        self.mapview.setRegion(region, animated: true)
    }

}


