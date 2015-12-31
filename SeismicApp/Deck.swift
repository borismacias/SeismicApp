//
//  Deck.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/28/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import Foundation
import CoreData

class Deck: NSManagedObject{
    
    @NSManaged var flashcards: [Flashcard]
    @NSManaged var name:String
    
    
    // MARK: - CoreData init
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(name:String, context: NSManagedObjectContext) {
        
        let entity =  NSEntityDescription.entityForName("Deck", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        self.name = name
        
    }

}
