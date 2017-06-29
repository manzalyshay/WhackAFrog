//
//  RecordsManager.swift
//  WhackAFrog
//
//  Created by admin on 28/06/2017.
//  Copyright © 2017 Anya&Qusay. All rights reserved.
//

import UIKit

class RecordsManager {

 var records: [Record] = []
 let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    init (){
        fetch()
    }
    
    func fetch(){
        do {
            records = try context.fetch(Record.fetchRequest())
            records = records.sorted(by: {$0.score > $1.score})
            
        } catch {
            print("Fetching Failed")
        }
        
    }
    
    func getRecords() -> [Record]{
        return records
    }
    
    func saveRecord(name: String, level: Int64, score: Int64, lat: Double, long: Double){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let record = Record(context: context) // Link Task & Context
        record.name = name
        record.level = level
        record.score = score
        record.lat = lat
        record.long = long
        
        // Save the data to coredata
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        fetch()
    }
    
    func isLimit() -> Bool{
        if (records.count < 10){
            return false
        }
        else {
            return true
        }
    }
    
    func getWorst() -> Int64{
        return records[records.count-1].score
    }
    
    func deleteRecord (){
        let record = records[records.count-1]
        context.delete(record)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        fetch()
    }
    
}
