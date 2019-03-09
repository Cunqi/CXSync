//
//  CXSyncParser.swift
//  CXSync
//
//  Created by Cunqi Xiao on 3/8/19.
//  Copyright © 2019 Cunqi Xiao. All rights reserved.
//

import CloudKit
import Foundation

protocol CXSyncParser {
    func parse(instance: CXSyncable) -> CKRecord
}

class CXStandardSyncParser: CXSyncParser {
    func parse(instance: CXSyncable) -> CKRecord {
        let record = instance.record
        let mirror = Mirror(reflecting: instance)
        for property in mirror.children {
            guard let key = property.label else {
                continue
            }

            if let value = property.value as? Array<Any>, type(of: value).Element.self is CKRecordValueProtocol {
                record[key] = value as CKRecordValue
            } else if let value = property.value as? CKRecordValueProtocol {
                record[key] = value
            } else if let value = property.value as? CXSyncAsset {
                record[key] = value.asset
            } else if let value = property as? CXSyncable {
                record[key] = CKRecord.Reference(recordID: value.recordID, action: .none)
            }
        }
        return record
    }
}
