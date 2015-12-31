//
//  Flashcard.swift
//  SeismicApp
//
//  Created by Boris Alexis Gonzalez Macias on 12/28/15.
//  Copyright © 2015 Leandoers. All rights reserved.
//

import UIKit
import CoreData

class Flashcard : NSManagedObject{

    @NSManaged var name:String
    @NSManaged var definition:String
    @NSManaged var deck:Deck
    @NSManaged var imageName:String
    @NSManaged var level:NSNumber
    
    // MARK: - CoreData init
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(name:String,definition:String,deck: Deck, imageName:String ,image:UIImage,context: NSManagedObjectContext) {
        
        let entity =  NSEntityDescription.entityForName("Flashcard", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.name = name
        self.deck = deck
        self.name = name
        self.imageName = name
        self.level = 1
        self.definition = definition
        
        self.storeImage(image)
    }

    func storeImage(image:UIImage) -> Void {
        let fileName = self.imageName
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let fileURL = NSURL.fileURLWithPathComponents([dirPath, fileName])
        let dataImage = UIImagePNGRepresentation(image)
        NSFileManager.defaultManager().createFileAtPath(fileURL!.path!, contents: dataImage, attributes: nil)
    }
    
    func getImage() -> UIImage? {
        let fileName = self.imageName
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let fileURL = NSURL.fileURLWithPathComponents([dirPath, fileName])
        return UIImage(contentsOfFile: fileURL!.path!)
    }
    
    override func prepareForDeletion() {
        let fileName = self.imageName
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let fileURL = NSURL.fileURLWithPathComponents([dirPath, fileName])!
        
        do{
            try NSFileManager.defaultManager().removeItemAtURL(fileURL)
        }catch{
        }
    }
    
}
