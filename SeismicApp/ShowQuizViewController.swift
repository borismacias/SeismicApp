//
//  ShowQuizViewController.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/28/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import UIKit

// Just shows the quiz
class ShowQuizViewController: UIViewController {
    
    var quiz:Quiz!
    
    @IBOutlet var questionLabel:UILabel!
    @IBOutlet var correctAnswer:UILabel!
    @IBOutlet var incorrectAnswer1:UILabel!
    @IBOutlet var incorrectAnswer2:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionLabel.text = quiz.question
        correctAnswer.text = quiz.correctAnswer
        incorrectAnswer1.text = quiz.failedAnswer1
        incorrectAnswer2.text = quiz.failedAnswer2
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
