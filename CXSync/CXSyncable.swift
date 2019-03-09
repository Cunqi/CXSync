//
//  CXSyncable.swift
//  CXSync
//
//  Created by Cunqi Xiao on 3/8/19.
//  Copyright © 2019 Cunqi Xiao. All rights reserved.
//

import Foundation
import CloudKit

public protocol CXSyncable {
    static var recordType: String { get }
    static var recordZone: CKRecordZone.ID { get }

    var record: CKRecord { get }
    var recordID: CKRecord.ID { get }
    var recordName: String { get }
}

public protocol CXSyncAsset {
    var asset: CKAsset { get }
}

public extension CXSyncable {
    static var recordZone: CKRecordZone.ID {
        return CKRecordZone.default().zoneID
    }

    var recordName: String {
        return UUID().uuidString
    }

    var recordID: CKRecord.ID {
        return CKRecord.ID(recordName: recordName, zoneID: Self.recordZone)
    }

    var record: CKRecord {
        return CKRecord(recordType: Self.recordType, recordID: recordID)
    }
}
