//
//  Entry.swift
//  JournalCloudKit
//
//  Created by Madison Kaori Shino on 7/8/19.
//  Copyright © 2019 Madi S. All rights reserved.
//

import Foundation
import CloudKit

class Entry {
    
    var title: String
    var bodyText: String
    var timeStamp: Date
    var cloudKitRecordID: CKRecord.ID
    
    var cloudKitRecord: CKRecord {
        let record = CKRecord(recordType: EntryConstants.typeKey)
        record.setValue(title, forKey: EntryConstants.titleKey)
        record.setValue(bodyText, forKey: EntryConstants.bodyTextKey)
        record.setValue(timeStamp, forKey: EntryConstants.timeStampKey)
        return record
    }
    
    init(title: String, bodyText: String, timeStamp: Date = Date(), cloudKitRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.cloudKitRecordID = cloudKitRecordID
    }
    
    init?(record: CKRecord) {
        guard let title = record[EntryConstants.titleKey] as? String,
        let bodyText = record[EntryConstants.bodyTextKey] as? String,
        let timeStamp = record[EntryConstants.timeStampKey] as? Date,
        let recordID = record[EntryConstants.recordIDKey] as? CKRecord.ID
            else { return nil }
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.cloudKitRecordID = recordID
    }
}

extension Entry: Equatable {
    
    static func ==(lhs: Entry, rhs: Entry) -> Bool {
        return lhs.title == rhs.title &&
                lhs.bodyText == rhs.bodyText &&
                lhs.timeStamp == rhs.timeStamp &&
                lhs.cloudKitRecordID == rhs.cloudKitRecordID
    }
}

struct EntryConstants {
    static let typeKey = "Entry"
    fileprivate static let titleKey = "Title"
    fileprivate static let bodyTextKey = "BodyText"
    fileprivate static let timeStampKey = "Timestamp"
    fileprivate static let recordIDKey = "RecordID"
}
