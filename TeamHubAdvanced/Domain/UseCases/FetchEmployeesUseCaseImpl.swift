//
//  FetchEmployeesUseCaseImpl.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 19/03/26.
//

import Foundation

final class FetchEmployeesUseCaseImpl: FetchEmployeesUseCase {
    
    private let repository: EmployeeRepository
    
    init(repository: EmployeeRepository) {
        self.repository = repository
    }
    
    func execute(
        page: Int,
        query: String?,
        filters: EmployeeFilters?
    ) async throws -> EmployeePage {
        
        return try await repository.fetchEmployees(
            page: page,
            query: query,
            filters: filters
        )
    }
}
