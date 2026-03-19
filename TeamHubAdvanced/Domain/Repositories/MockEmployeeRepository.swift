//
//  MockEmployeeRepository.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 19/03/26.
//

import Foundation

final class MockEmployeeRepository: EmployeeRepository {
    func sync() async {
    
    }
    
    
    func fetchEmployees(
        page: Int,
        query: String?,
        filters: EmployeeFilters?
    ) async throws -> EmployeePage {
        
        try await Task.sleep(nanoseconds: 1_000_000_000) // simulate delay
        
        let employees = (1...10).map { index in
            Employee(
                id: "\(page)-\(index)",
                name: "Employee \(index + (page-1)*10)",
                designation: "iOS Developer",
                department: "Engineering",
                isActive: Bool.random(),
                imageURL: nil
            )
        }
        
        return EmployeePage(
            employees: employees,
            hasMore: page < 3
        )
    }
}
