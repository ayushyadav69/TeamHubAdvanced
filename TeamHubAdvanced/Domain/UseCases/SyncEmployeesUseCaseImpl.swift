//
//  SyncEmployeesUseCaseImpl.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 19/03/26.
//

import Foundation

final class SyncEmployeesUseCaseImpl: SyncEmployeesUseCase {
    
    private let repository: EmployeeRepository
    
    init(repository: EmployeeRepository) {
        self.repository = repository
    }
    
    func execute() async {
        await repository.sync()
    }
}
