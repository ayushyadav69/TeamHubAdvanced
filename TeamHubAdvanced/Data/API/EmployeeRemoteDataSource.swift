//
//  EmployeeRemoteDataSource.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 19/03/26.
//

import Foundation

final class EmployeeRemoteDataSource {
    
    func fetchEmployees(
        page: Int,
        query: String?,
        filters: EmployeeFilters?
    ) async throws -> [Employee] {
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        let pageSize = 10
        let total = 48   //  simulate backend total
        
        let start = (page - 1) * pageSize
        
        guard start < total else {
            return []   // no more data
        }
        
        let end = min(start + pageSize, total)
        
        return (start..<end).map { index in
            Employee(
                id: "\(index)",
                name: "Employee \(index)",
                designation: "iOS Developer",
                department: "Engineering",
                isActive: Bool.random(),
                imageURL: nil
            )
        }
    }
    
    func createEmployee(_ entity: EmployeeEntity) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
    }

    func updateEmployee(_ entity: EmployeeEntity) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
    }

    func deleteEmployee(id: String) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
    }

    func fetchChanges(since: Date?) async throws -> [Employee] {
        // simulate "no new changes"
        return []
    }
}
