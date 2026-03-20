//
//  DeleteEmployeeUseCase.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 20/03/26.
//

import Foundation

protocol DeleteEmployeeUseCase {
    func execute(id: String) throws
}

final class DeleteEmployeeUseCaseImpl: DeleteEmployeeUseCase {
    
    private let repository: EmployeeRepository
    
    init(repository: EmployeeRepository) {
        self.repository = repository
    }
    
    func execute(id: String) throws {
        try repository.deleteEmployee(id: id)
    }
}
