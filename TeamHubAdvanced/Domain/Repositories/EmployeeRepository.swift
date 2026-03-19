//
//  EmployeeRepository.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 19/03/26.
//

import Foundation

protocol EmployeeRepository {
    
    func fetchEmployees(
        page: Int,
        query: String?,
        filters: EmployeeFilters?
    ) async throws -> EmployeePage
    
    func sync() async
}
