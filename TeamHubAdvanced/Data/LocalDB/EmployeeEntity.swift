//
//  EmployeeEntity.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 19/03/26.
//

import SwiftData
import Foundation

@Model
final class EmployeeEntity {
    
    @Attribute(.unique)
    var id: String
    
    var name: String
    var designation: String
    var department: String
    var isActive: Bool
    
    var email: String
    var city: String
    var country: String

    var imageURL: String?

    var phoneNumbersData: String 
    
    // Sync fields (optional → backend-safe)
    var createdAt: Date?
    var updatedAt: Date?
    var deletedAt: Date?
    
    var syncState: SyncState
    
    init(
        id: String,
        name: String,
        designation: String,
        department: String,
        isActive: Bool,
        email: String,
        city: String,
        country: String,
        imageURL: String?,
        phoneNumbersData: String,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        deletedAt: Date? = nil,
        syncState: SyncState = .synced
    ) {
        self.id = id
        self.name = name
        self.designation = designation
        self.department = department
        self.isActive = isActive
        self.email = email
        self.city = city
        self.country = country
        self.imageURL = imageURL
        self.phoneNumbersData = phoneNumbersData
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
        self.syncState = syncState
    }
}
