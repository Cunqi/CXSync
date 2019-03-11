//
//  CXSyncManager.swift
//  CXSync
//
//  Created by Cunqi on 3/9/19.
//  Copyright © 2019 Cunqi Xiao. All rights reserved.
//

import CloudKit
import Foundation

struct SubscriptionInfo: Codable {
    private static let subscriptionID = "private-changes"
    private static let changedFlagKey = "CXSubscriptionIsLocallyChanged"
    private static let changedTokenKey = "CXChangedToken"
    
    var subscriptionIsLocallyChanged: Bool
    var changedToken: Data?
    
    func save() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(subscriptionIsLocallyChanged, forKey: SubscriptionInfo.changedFlagKey)
        userDefaults.set(changedToken, forKey: SubscriptionInfo.changedFlagKey)
        userDefaults.synchronize()
    }
    
    static func load() -> SubscriptionInfo {
        let userDefaults = UserDefaults.standard
        let changedFlag = userDefaults.bool(forKey: SubscriptionInfo.changedFlagKey)
        let changedToken = userDefaults.data(forKey: SubscriptionInfo.changedTokenKey)
        return SubscriptionInfo(subscriptionIsLocallyChanged: changedFlag, changedToken: changedToken)
    }
    
    func getSubscription() -> CKDatabaseSubscription {
        let subscription = CKDatabaseSubscription(subscriptionID: SubscriptionInfo.subscriptionID)
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        return subscription
    }
}

public class CXSyncManager {
    public static let shared = CXSyncManager()
    
    private(set) var subscriptionInfo: SubscriptionInfo
    private var container: CKContainer
    private var database: CKDatabase
    
    private init() {
        subscriptionInfo = SubscriptionInfo.load()
        container = CKContainer.default()
        database = container.privateCloudDatabase
    }
    
    public func registerSubscriptions() {
        guard !subscriptionInfo.subscriptionIsLocallyChanged else {
            return
        }
        let subscription = subscriptionInfo.getSubscription()
        let operation = CKModifySubscriptionsOperation(subscriptionsToSave: [subscription], subscriptionIDsToDelete: [])
        operation.modifySubscriptionsCompletionBlock = { [weak self] _, _, error in
            guard error == nil else {
                return
            }
            self?.subscriptionInfo.subscriptionIsLocallyChanged = true
            self?.subscriptionInfo.save()
        }
        operation.qualityOfService = .utility
        database.add(operation)
    }
    
    public func sync(_ recordsToSave: [CXSyncable]?, _ recordsToDelete: [CXSyncable]?) {
        let saveable = recordsToSave?.map { $0.record }
        let deletable = recordsToDelete?.map { $0.recordID }
        let recordModification = CKModifyRecordsOperation(recordsToSave: saveable, recordIDsToDelete: deletable)
        
        if #available(iOS 11.0, *) {
            let configuration = CKOperation.Configuration()
            configuration.isLongLived = true
            recordModification.configuration = configuration
        } else {
            recordModification.isLongLived = true
        }
        recordModification.savePolicy = .changedKeys
        recordModification.isAtomic = true
    }
}
