//
//  Flashcard.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/27/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import CoreData

class Flashcard:NSManagedObject{
    
    @NSManaged var question:String
    @NSManaged var correctAnswer:String
    @NSManaged var failedAnswer1:String
    @NSManaged var failedAnswer2:String
    @NSManaged var level:NSNumber


}
