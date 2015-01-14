//
//  CoreData.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-12.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import CoreData

func saveToken(value: String) {
    saveValue(value, "User", "token")
}

func deleteToken(row: Int) {
    deleteValue(row, "User")
}

func getToken() -> String {
    var results: AnyObject = getValue("User")
    
    var token = ""
    if results.count > 0 {
        token = results[0].valueForKey("token") as String!
    }
    return token
}

func saveStory(value: String) {
    saveValue(value, "Story", "id")
}

func getStory() -> AnyObject {
    var results: AnyObject = getValue("Story")
    return results
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