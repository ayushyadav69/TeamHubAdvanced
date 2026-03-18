//
//  FetchEmployeesUseCase.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 18/03/26.
//

import Foundation

protocol FetchEmployeesUseCase {
    func execute(
        page: Int,
        query: String?,
        filters: EmployeeFilters?
    ) async throws -> EmployeePage
}

struct DummyUseCase: FetchEmployeesUseCase {
    func execute(page: Int, query: String?, filters: EmployeeFilters?) async throws -> EmployeePage {
        return EmployeePage(employees: [], hasMore: false)
    }
}
