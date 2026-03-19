//
//  RootView.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 19/03/26.
//

import SwiftUI
import SwiftData

struct RootView: View {
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        
        let local = EmployeeLocalDataSource(context: context)
        let remote = EmployeeRemoteDataSource()
        let network = DefaultNetworkMonitor()
        let config = PaginationConfig(pageSize: 10)

        let repository = DefaultEmployeeRepository(
            remote: remote,
            local: local,
            networkMonitor: network,
            config: config
        )
        
        let useCase = FetchEmployeesUseCaseImpl(repository: repository)
        let syncUseCase = SyncEmployeesUseCaseImpl(repository: repository)
        
        let viewModel = EmployeeListViewModel(
            fetchEmployeesUseCase: useCase,
            syncUseCase: syncUseCase
        )
        
        EmployeeListView(viewModel: viewModel)
    }
}
