//
//  AddEmployeeUseCase.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 20/03/26.
//

import Foundation

protocol AddEmployeeUseCase {
    func execute(_ employee: Employee) throws
}

final class AddEmployeeUseCaseImpl: AddEmployeeUseCase {
    
    private let repository: EmployeeRepository
    
    init(repository: EmployeeRepository) {
        self.repository = repository
    }
    
    func execute(_ employee: Employee) throws {
        try repository.addEmployee(employee)
    }
}
