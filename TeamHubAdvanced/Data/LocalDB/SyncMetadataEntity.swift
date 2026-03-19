//
//  SyncMetadataEntity.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 19/03/26.
//

import SwiftData
import Foundation

@Model
final class SyncMetadataEntity {
    
    @Attribute(.unique)
    var id: String   // always "employee_sync"
    
    var lastSyncDate: Date?
    
    init(id: String = "employee_sync", lastSyncDate: Date? = nil) {
        self.id = id
        self.lastSyncDate = lastSyncDate
    }
}
