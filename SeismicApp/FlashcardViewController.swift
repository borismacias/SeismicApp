//
//  FlashcardViewController.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/30/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import UIKit

class FlashcardViewController: UIViewController {
    
    var flashcard:Flashcard!
    var level = 1
    
    @IBOutlet var flashcardImage:UIImageView!
    @IBOutlet var button:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flashcardImage.image = flashcard.getImage()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAnswer" {
            let destinationVC = segue.destinationViewController as! AnswerViewController
            destinationVC.flashcard = self.flashcard
        }
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
