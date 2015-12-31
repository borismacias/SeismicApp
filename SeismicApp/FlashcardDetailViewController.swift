//
//  FlashcardDetailViewController.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/30/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import UIKit

class FlashcardDetailViewController: UIViewController {
    
    @IBOutlet var imageView:UIImageView!
    @IBOutlet var name:UILabel!
    @IBOutlet var definition:UITextView!

    @IBAction func done(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var flashcard:Flashcard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = self.flashcard.getImage()
        self.name.text = self.flashcard.name
        self.definition.text = self.flashcard.definition
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
