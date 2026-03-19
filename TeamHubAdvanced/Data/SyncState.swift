//
//  SyncState.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 19/03/26.
//

import Foundation

enum SyncState: String, Codable {
    case synced
    case pendingCreate
    case pendingUpdate
    case pendingDelete
}
