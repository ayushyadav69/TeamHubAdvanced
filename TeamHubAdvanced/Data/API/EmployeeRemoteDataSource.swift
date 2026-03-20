//
//  EmployeeRemoteDataSource.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 19/03/26.
//

import Foundation

final class EmployeeRemoteDataSource {
    
    private let pageSize = 10
    private let total = 48   // simulate backend dataset
    
    // Simulated backend storage (IMPORTANT)
    private var allEmployees: [Employee] = []
    
    init() {
        self.allEmployees = Self.generateMockData(total: total)
    }
    
    func fetchEmployees(
        page: Int,
        query: String?,
        filters: EmployeeFilters?
    ) async throws -> [Employee] {
        
        try await Task.sleep(nanoseconds: 300_000_000)
        
        var data = allEmployees
        
        // 🔍 SEARCH
        if let query, !query.isEmpty {
            data = data.filter {
                $0.name.localizedCaseInsensitiveContains(query) ||
                $0.designation.localizedCaseInsensitiveContains(query) ||
                $0.department.localizedCaseInsensitiveContains(query)
            }
        }
        
        // 🎯 FILTERS
        if let filters {
            
            if let designation = filters.designation {
                data = data.filter { $0.designation == designation }
            }
            
            if let department = filters.department {
                data = data.filter { $0.department == department }
            }
            
            if let isActive = filters.isActive {
                data = data.filter { $0.isActive == isActive }
            }
        }
        
        // 📄 PAGINATION
        let start = (page - 1) * pageSize
        
        guard start < data.count else {
            return []
        }
        
        let end = min(start + pageSize, data.count)
        
        return Array(data[start..<end])
    }
    
    // MARK: - CRUD
    
    func createEmployee(_ entity: EmployeeEntity) async throws {
        try await Task.sleep(nanoseconds: 200_000_000)
        
        let employee = EmployeeMapper.toDomain(entity)
        allEmployees.insert(employee, at: 0)
    }
    
    func updateEmployee(_ entity: EmployeeEntity) async throws {
        try await Task.sleep(nanoseconds: 200_000_000)
        
        let updated = EmployeeMapper.toDomain(entity)
        
        if let index = allEmployees.firstIndex(where: { $0.id == updated.id }) {
            allEmployees[index] = updated
        }
    }
    
    func deleteEmployee(id: String) async throws {
        try await Task.sleep(nanoseconds: 200_000_000)
        
        allEmployees.removeAll { $0.id == id }
    }
    
    // MARK: - Sync
    
    func fetchChanges(since: Date?) async throws -> [Employee] {
        // simple mock → return nothing for now
        return []
    }
}

private extension EmployeeRemoteDataSource {
    
    static func generateMockData(total: Int) -> [Employee] {
        
        let designations = ["iOS Developer", "Manager", "HR", "Backend Engineer"]
        let departments = ["Engineering", "HR", "Finance"]
        let cities = ["Delhi", "Noida", "Mumbai", "Bangalore"]
        let countries = ["India"]
        
        return (0..<total).map { index in
            
            Employee(
                id: "\(index)",
                name: "Employee \(index)",
                email: "employee\(index)@test.com",
                designation: designations[index % designations.count],
                department: departments[index % departments.count],
                city: cities[index % cities.count],
                country: countries[0],
                isActive: index % 2 == 0,
                imageURL: nil,
                phoneNumbers: [
                    PhoneNumber(number: "99999\(1000 + index)", type: "home")
                ]
            )
        }
    }
}
