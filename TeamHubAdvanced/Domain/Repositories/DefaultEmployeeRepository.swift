//
//  DefaultEmployeeRepository.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 19/03/26.
//

import Foundation

final class DefaultEmployeeRepository: EmployeeRepository {
    
    private let remote: EmployeeRemoteDataSource
    private let local: EmployeeLocalDataSource
    private let networkMonitor: NetworkMonitor
    private let config: PaginationConfig
    
    init(
        remote: EmployeeRemoteDataSource,
        local: EmployeeLocalDataSource,
        networkMonitor: NetworkMonitor,
        config: PaginationConfig
    ) {
        self.remote = remote
        self.local = local
        self.networkMonitor = networkMonitor
        self.config = config
    }
    
    func fetchEmployees(
        page: Int,
        query: String?,
        filters: EmployeeFilters?
    ) async throws -> EmployeePage {
        
        let pageSize = config.pageSize
        
        //  Try LOCAL FIRST (always)
        let localEntities = try local.fetchEmployees(
            page: page,
            pageSize: pageSize,
            query: query,
            filters: filters
        )
        
        //  If enough data OR offline → return local
        if !localEntities.isEmpty || !networkMonitor.isConnected {
            
            return EmployeePage(
                employees: localEntities.map { EmployeeMapper.toDomain($0) },
                hasMore: localEntities.count == pageSize
            )
        }
        
        //  Otherwise fetch from API
        let remoteEmployees = try await remote.fetchEmployees(
            page: page,
            query: query,
            filters: filters
        )
        
        // Save ONLY if not search/filter
        let isSearch = query != nil || filters != nil
        
        if !isSearch {
            let entities = remoteEmployees.map {
                EmployeeMapper.toEntity(
                    from: $0,
                    createdAt: nil,
                    updatedAt: Date(),
                    deletedAt: nil
                )
            }
            
            try local.upsert(entities)
        }
        
        return EmployeePage(
            employees: remoteEmployees,
            hasMore: remoteEmployees.count == pageSize
        )
    }
    
    func sync() async {
        
        guard networkMonitor.isConnected else { return }
        
        do {
            try await pushPendingChanges()
            try await pullLatestChanges()
        } catch {
            print("Sync failed:", error)
        }
    }
    
    private func pushPendingChanges() async throws {
        
        let entities = try local.fetchAllIncludingDeleted()
        
        for entity in entities {
            
            switch entity.syncState {
                
            case .pendingCreate:
                try await remote.createEmployee(entity)
                entity.syncState = .synced
                entity.updatedAt = Date()
                
            case .pendingUpdate:
                try await remote.updateEmployee(entity)
                entity.syncState = .synced
                entity.updatedAt = Date()
                
            case .pendingDelete:
                try await remote.deleteEmployee(id: entity.id)
                try local.delete(entity)   // remove after server confirms
                
            case .synced:
                continue
            }
        }
        
        try local.saveContext()
    }
    
    private func pullLatestChanges() async throws {
        
        let lastSync = try local.getLastSyncDate()
        
        let changes = try await remote.fetchChanges(since: lastSync)
        
        let entities = changes.map {
            EmployeeMapper.toEntity(
                from: $0,
                createdAt: nil,
                updatedAt: Date(),   // mark latest
                deletedAt: nil
            )
        }
        
        try local.upsert(entities)
        
        try local.updateLastSyncDate(Date())
    }
    
    func addEmployee(_ employee: Employee) throws {
        
        let entity = EmployeeMapper.toEntity(
            from: employee,
            createdAt: Date(),
            updatedAt: Date(),
            deletedAt: nil
        )
        
        entity.syncState = .pendingCreate
        
        try local.upsert([entity])
    }
    
    func updateEmployee(_ employee: Employee) throws {
        
        let entities = try local.fetchAllIncludingDeleted()
        
        guard let entity = entities.first(where: { $0.id == employee.id }) else { return }
        
        entity.name = employee.name
        entity.designation = employee.designation
        entity.department = employee.department
        entity.isActive = employee.isActive
        entity.updatedAt = Date()
        
        if entity.syncState == .synced {
            entity.syncState = .pendingUpdate
        }
        
        try local.saveContext()
    }
    
    func deleteEmployee(id: String) throws {
        
        let entities = try local.fetchAllIncludingDeleted()
        
        guard let entity = entities.first(where: { $0.id == id }) else { return }
        
        entity.deletedAt = Date()
        entity.syncState = .pendingDelete
        
        try local.saveContext()
    }
}
