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
    
    init(title: String, bodyText: String, timeStamp: Date = Date(), cloudKitRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.cloudKitRecordID = cloudKitRecordID
    }
    
    //INITIALIZE RECORD FROM CK INTO AN ENTRY
    convenience init?(record: CKRecord) {
        guard let title = record[EntryConstants.titleKey] as? String,
        let bodyText = record[EntryConstants.bodyTextKey] as? String,
        let timeStamp = record[EntryConstants.timeStampKey] as? Date
            else { return nil }
        self.init(title: title, bodyText:bodyText, timeStamp:timeStamp, cloudKitRecordID:record.recordID)
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

extension CKRecord {
    
    convenience init(entry: Entry) {
        self.init(recordType: EntryConstants.recordType, recordID: entry.cloudKitRecordID)
        self.setValue(entry.title, forKey: EntryConstants.titleKey)
        self.setValue(entry.bodyText, forKey: EntryConstants.bodyTextKey)
        self.setValue(entry.timeStamp, forKey: EntryConstants.timeStampKey)
    }
}

struct EntryConstants {
    static let typeKey = "Entry"
    fileprivate static let titleKey = "Title"
    fileprivate static let bodyTextKey = "BodyText"
    fileprivate static let timeStampKey = "Timestamp"
    fileprivate static let recordType = "Entry"
}
