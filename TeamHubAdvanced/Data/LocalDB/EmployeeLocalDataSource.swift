//
//  EmployeeLocalDataSource.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 19/03/26.
//

import SwiftData
import Foundation

final class EmployeeLocalDataSource {
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // Fetch
    
    func fetchEmployees(
        page: Int,
        pageSize: Int,
        query: String?,
        filters: EmployeeFilters?
    ) throws -> [EmployeeEntity] {
        
        let offset = (page - 1) * pageSize
        
        //  Normalize input
        let search = query?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        let designation = filters?.designation
        let department = filters?.department
        let isActive = filters?.isActive
        
        let hasSearch = search != nil && !(search?.isEmpty ?? true)
        
        //  Build descriptor
        var descriptor = FetchDescriptor<EmployeeEntity>(
            predicate: #Predicate<EmployeeEntity> { entity in
                
                //  SEARCH
                (
                    !hasSearch
                    ||
                    entity.name.localizedStandardContains(search!)
                    ||
                    entity.designation.localizedStandardContains(search!)
                    ||
                    entity.department.localizedStandardContains(search!)
                )
                
                //  DESIGNATION
                &&
                (
                    designation == nil
                    ||
                    entity.designation == designation!
                )
                
                //  DEPARTMENT
                &&
                (
                    department == nil
                    ||
                    entity.department == department!
                )
                
                //  STATUS
                &&
                (
                    isActive == nil
                    ||
                    entity.isActive == isActive!
                )
                
                //  SOFT DELETE
                &&
                entity.deletedAt == nil
            },
            
            //  STABLE SORT (VERY IMPORTANT)
            sortBy: [
                SortDescriptor(\EmployeeEntity.name, order: .forward),
                SortDescriptor(\EmployeeEntity.id, order: .forward)
            ]
        )
        
        //  DB PAGINATION
        descriptor.fetchLimit = pageSize
        descriptor.fetchOffset = offset
        
        return try context.fetch(descriptor)
    }
    
    // Save / Upsert
    
    func upsert(_ entities: [EmployeeEntity]) throws {
        
        for newEntity in entities {
            
            let id = newEntity.id
            
            let descriptor = FetchDescriptor<EmployeeEntity>(
                predicate: #Predicate { $0.id == id }
            )
            
            if let existing = try context.fetch(descriptor).first {
                
                // If local changes exist → DON'T overwrite
                if existing.syncState != .synced {
                    continue
                }
                
                //  UPDATE existing
                existing.name = newEntity.name
                existing.designation = newEntity.designation
                existing.department = newEntity.department
                existing.isActive = newEntity.isActive
                existing.imageURL = newEntity.imageURL
                existing.updatedAt = newEntity.updatedAt
                
                if newEntity.deletedAt != nil {
                    existing.deletedAt = newEntity.deletedAt
                }
                
                //  ONLY update syncState if safe
                if existing.syncState == .synced {
                    existing.syncState = .synced
                }
                
            } else {
                
                // ➕ INSERT new
                context.insert(newEntity)
            }
        }
        
        try context.save()
    }
    
    func fetchAllIncludingDeleted() throws -> [EmployeeEntity] {
        try context.fetch(FetchDescriptor<EmployeeEntity>())
    }

    func delete(_ entity: EmployeeEntity) throws {
        context.delete(entity)
    }

    func saveContext() throws {
        try context.save()
    }
    
    func getLastSyncDate() throws -> Date? {
        
        let descriptor = FetchDescriptor<SyncMetadataEntity>()
        
        if let metadata = try context.fetch(descriptor).first {
            return metadata.lastSyncDate
        }
        
        return nil
    }
    
    func updateLastSyncDate(_ date: Date) throws {
        
        let descriptor = FetchDescriptor<SyncMetadataEntity>()
        
        if let metadata = try context.fetch(descriptor).first {
            metadata.lastSyncDate = date
        } else {
            let new = SyncMetadataEntity(lastSyncDate: date)
            context.insert(new)
        }
        
        try context.save()
    }
}
