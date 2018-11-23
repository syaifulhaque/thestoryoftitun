//
//  CloudKitHelper.swift
//  StoviTheStoryVideo
//
//  Created by Agatha Rachmat on 22/11/18.
//  Copyright © 2018 Egi Muhamad Saefulhaqi. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

typealias onSaveSuccess = (CKRecord)-> Void // func onsavesucess data CKrecord with data Void
typealias onFetchRecordSuccess = ([Story])->Void // void=()
class CloudKitHelper {
    
    func createStoryRecord(story: Story){
        let record = CKRecord(recordType: "Story")
        record["title"] = story.title
        record["image"] = story.image
        record["description"] = story.content
        
    }
    
    func fetchStoryRecord(onfetchSucsess: @escaping onFetchRecordSuccess){
        let container = CKContainer.default()
        let database = container.publicCloudDatabase
        // let records = CKRecord(recordType: "Story")
         let predicate = NSPredicate(value: true) // choose the data we want like below
        //let predicate = NSPredicate(format: "title = %@", "Youtube")
        let query = CKQuery(recordType: "Story", predicate: predicate)
        database.perform(query, inZoneWith: nil ) {(records,error) in
            //    print(records)
            
            var stories:[Story] = []
            print("Error : \(error?.localizedDescription)")
            //unwrapping
            if let fetchedRecords = records{
                print("record : \(records)")
                for record in fetchedRecords{
                    let story = self.convertRecordToStory(record: record)
                    if let convertedStory = story{
                        stories.append(convertedStory)
                        print("Halle : \(convertedStory)")
                    }
                }
            }
            onfetchSucsess(stories)
            //            records?.forEach(<#T##body: (CKRecord) throws -> Void##(CKRecord) throws -> Void#>)
            
        }
        print("end of func", #function)
    }
    
    func convertRecordToStory(record: CKRecord)-> Story?{
        guard let title = record["title"] as? String,
            let description = record["content"] as? String,
            let videoUrl = record["videoUrl"] as? String,
            let thumbnail = record["image"] as? String else {
                return nil
        }
        do {
            
            let story = try Story(title: title ,image: thumbnail, content: description, videoUrl: videoUrl)
            return story
            
        } catch  {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
}
