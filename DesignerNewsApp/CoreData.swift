//
//  CoreData.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-12.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import CoreData

func saveUpvote(value: String) {
    saveValue(value, "Story", "id")
}

func getUpvotes() -> NSArray {
    var results: NSArray = getValue("Story") as NSArray
    
    var upvotes = [""]
    for result in results {
        let value = result.valueForKey("id") as String
        upvotes.append(value)
    }
    
    return upvotes as NSArray
}

func saveValue(value: String, table: String, key: String) {
        
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    let managedContext = appDelegate.managedObjectContext!
    
    let entity =  NSEntityDescription.entityForName(table, inManagedObjectContext: managedContext)
    let row = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
    row.setValue(value, forKey: key)
    
    var error: NSError?
    if !managedContext.save(&error) {
        println("Could not save \(error), \(error?.userInfo)")
    }
}

func deleteValue(row: Int, table: String) {
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    let managedContext = appDelegate.managedObjectContext!
    
    let request = NSFetchRequest(entityName:table)
    var error: NSError?
    let results = managedContext.executeFetchRequest(request, error: &error) as [NSManagedObject]!
    
    managedContext.deleteObject(results[row])
    
    if !managedContext.save(&error) {
        println("Could not save \(error), \(error?.userInfo)")
    }
}

func getValue(table: String) -> AnyObject! {
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    let managedContext = appDelegate.managedObjectContext!
    
    let request = NSFetchRequest(entityName: table)
    var error: NSError?
    let results = managedContext.executeFetchRequest(request, error: &error) as [NSManagedObject]!
    
    return results
}