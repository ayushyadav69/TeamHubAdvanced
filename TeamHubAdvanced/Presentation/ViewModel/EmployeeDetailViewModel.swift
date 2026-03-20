//
//  EmployeeDetailViewModel.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 20/03/26.
//

import Foundation
import Observation

@Observable
final class EmployeeDetailViewModel {
    
    var employee: Employee
    var showEdit = false
    
    private let updateUseCase: UpdateEmployeeUseCase
    private let syncUseCase: SyncEmployeesUseCase
    
    init(
        employee: Employee,
        updateUseCase: UpdateEmployeeUseCase,
        syncUseCase: SyncEmployeesUseCase
    ) {
        self.employee = employee
        self.updateUseCase = updateUseCase
        self.syncUseCase = syncUseCase
    }
    
    func onEditTapped() {
        showEdit = true
    }
    
    func onEmployeeUpdated(_ updated: Employee) {
        
        // update local state (UI refresh)
        self.employee = updated
        
        // persist
        try? updateUseCase.execute(updated)
        
        // sync
        Task {
            await syncUseCase.execute()
        }
    }
}
