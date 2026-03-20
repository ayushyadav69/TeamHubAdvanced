//
//  UpdateEmployeeUseCase.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 20/03/26.
//

import Foundation

protocol UpdateEmployeeUseCase {
    func execute(_ employee: Employee) throws
}

final class UpdateEmployeeUseCaseImpl: UpdateEmployeeUseCase {
    
    private let repository: EmployeeRepository
    
    init(repository: EmployeeRepository) {
        self.repository = repository
    }
    
    func execute(_ employee: Employee) throws {
        try repository.updateEmployee(employee)
    }
}
