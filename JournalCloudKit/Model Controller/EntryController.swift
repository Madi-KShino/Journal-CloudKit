//
//  EntryController.swift
//  JournalCloudKit
//
//  Created by Madison Kaori Shino on 7/8/19.
//  Copyright © 2019 Madi S. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    
    static let sharedInstance = EntryController()
    
    var entries: [Entry] = []
    
    func save(entry: Entry, completion: @escaping (Bool) -> ()) {
        let record = CKRecord(entry: entry)
        CKContainer.default().privateCloudDatabase.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(false)
                return
            }
            guard let record = record,
                let entry = Entry(record: record)
                else { completion(false); return }
            self.entries.append(entry)
            completion(true)
        }
    }
    
    func addEntryWith(title: String, bodyText: String, completion: @escaping (Bool) -> Void) {
        let entry = Entry(title: title, bodyText: bodyText)
        save(entry: entry, completion: completion)
    }
    
    func fetchEntries(completion: @escaping (Bool) -> ()) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryConstants.typeKey, predicate: predicate)
        CKContainer.default().privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(false)
                return
            }
            guard let records = records else { completion(false); return }
            let entries = records.compactMap{Entry(record: $0)}
            self.entries = entries
            completion(true)
        }
    }
    
    func updateEntry(entry: Entry, title: String, body: String) {
        let title = entry.title
        let body = entry.bodyText
        
        let database = CKContainer.default().privateCloudDatabase
        database.fetch(withRecordID: entry.cloudKitRecordID) { (record, error) in
            if let recordToSave = record {
                recordToSave.setObject(title as __CKRecordObjCValue, forKey: "title")
                recordToSave.setObject(body as __CKRecordObjCValue, forKey: "body")
                
                let operation = CKModifyRecordsOperation(recordsToSave: [recordToSave], recordIDsToDelete: nil)
                operation.savePolicy = CKModifyRecordsOperation.RecordSavePolicy.allKeys
                operation.qualityOfService = QualityOfService.userInitiated
                operation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
                    if error == nil {
                        print("Entry Updated")
                    } else {
                        print(error as Any)
                    }
                }
                database.add(operation)
            } else {
                print(error.debugDescription)
            }
        }
    }
}
