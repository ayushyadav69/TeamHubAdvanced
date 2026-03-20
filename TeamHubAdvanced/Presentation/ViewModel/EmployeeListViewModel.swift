//
//  EmployeeListViewModel.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 18/03/26.
//

import Observation

@Observable
final class EmployeeListViewModel {
    
    // MARK: - Dependencies
    
    private let fetchEmployeesUseCase: FetchEmployeesUseCase
    private let addEmployeeUseCase: AddEmployeeUseCase
    private let updateEmployeeUseCase: UpdateEmployeeUseCase
    private let deleteEmployeeUseCase: DeleteEmployeeUseCase
    private let syncUseCase: SyncEmployeesUseCase
    
    // MARK: - State
    
    var state: EmployeeListViewState
    var searchText: String = ""
    
    private var currentPage = 1
    private var hasMore = true
    private var isLoading = false
    
    // MARK: - Init
    
    init(
        fetchEmployeesUseCase: FetchEmployeesUseCase,
        addEmployeeUseCase: AddEmployeeUseCase,
        updateEmployeeUseCase: UpdateEmployeeUseCase,
        deleteEmployeeUseCase: DeleteEmployeeUseCase,
        syncUseCase: SyncEmployeesUseCase
    ) {
        self.fetchEmployeesUseCase = fetchEmployeesUseCase
        self.addEmployeeUseCase = addEmployeeUseCase
        self.updateEmployeeUseCase = updateEmployeeUseCase
        self.deleteEmployeeUseCase = deleteEmployeeUseCase
        self.syncUseCase = syncUseCase
        self.state = .loading
    }
    
    func onAppear() {
        guard state.employees.isEmpty else { return }
        
        Task {
            await syncUseCase.execute()
            loadFirstPage()
        }
    }
    
    func onRefresh() {
        Task {
            await syncUseCase.execute()   // sync first
            loadFirstPage()
        }
    }
    
    private func loadFirstPage() {
        currentPage = 1
        hasMore = true
        state = .loading
        fetchEmployees(reset: true)
    }
    
    func onItemAppear(_ id: String) {
        
        guard let last = state.employees.last else { return }
        
        if last.id == id {
            loadNextPage()
        }
    }
    
    func onEmployeeTap(_ id: String) {
        // navigation will be handled later
    }
    
    private func loadNextPage() {
        
        guard hasMore else { return }
        guard !isLoading else { return }
        
        currentPage += 1
        
        fetchEmployees(reset: false)
    }
    
    private func fetchEmployees(reset: Bool) {
        
        guard !isLoading else { return }
        isLoading = true
        
        if reset {
            state = .loading
        }
        
        Task {
            do {
                let page = try await fetchEmployeesUseCase.execute(
                    page: currentPage,
                    query: searchText.isEmpty ? nil : searchText,
                    filters: nil
                )
                
                let newItems = page.employees.map { mapToUI($0) }
                
                await MainActor.run {
                    
                    if reset {
                        state = buildLoadedState(items: newItems)
                    } else {
                        state = buildLoadedState(items: state.employees + newItems)
                    }
                    
                    hasMore = page.hasMore
                    isLoading = false
                }
                
            } catch {
                await MainActor.run {
                    state = buildErrorState()
                    isLoading = false
                }
            }
        }
    }
    
    func onDeleteEmployee(_ id: String) {
        
        try? deleteEmployeeUseCase.execute(id: id)
        
        state = buildLoadedState(
            items: state.employees.filter { $0.id != id }
        )
        
        Task {
            await syncUseCase.execute()
        }
    }
    
    private func mapToUI(_ employee: Employee) -> EmployeeListItemUIModel {
        EmployeeListItemUIModel(
            id: employee.id,
            name: employee.name,
            designation: employee.designation,
            department: employee.department,
            imageURL: employee.imageURL,
            isActive: employee.isActive
        )
    }
    

    
    private func buildLoadedState(items: [EmployeeListItemUIModel]) -> EmployeeListViewState {
        EmployeeListViewState(
            employees: items,
            isLoading: false,
            isRefreshing: false,
            isLoadingNextPage: false,
            isEmpty: items.isEmpty,
            errorMessage: nil,
            emptyImageName: "tray",
            errorImageName: "exclamationmark.triangle",
            searchPlaceholder: "Search employees",
            emptyTitle: "No Employees Found",
            emptySubtitle: "Try adjusting filters",
            retryButtonTitle: "Retry"
        )
    }
    
    private func buildErrorState() -> EmployeeListViewState {
        EmployeeListViewState(
            employees: [],
            isLoading: false,
            isRefreshing: false,
            isLoadingNextPage: false,
            isEmpty: false,
            errorMessage: "Something went wrong",
            emptyImageName: "",
            errorImageName: "exclamationmark.triangle",
            searchPlaceholder: "Search employees",
            emptyTitle: "",
            emptySubtitle: "",
            retryButtonTitle: "Retry"
        )
    }
    
    func onEmployeeAdded(_ employee: Employee) {
        
        try? addEmployeeUseCase.execute(employee)
        
        let item = mapToUI(employee)
        
        state = buildLoadedState(
            items: [item] + state.employees
        )
        
        Task {
            await syncUseCase.execute()
        }
    }
    
    func makeDetailViewModel(
        employee: EmployeeListItemUIModel
    ) -> EmployeeDetailViewModel {
        
        let domain = Employee(
            id: employee.id,
            name: employee.name,
            email: "test@email.com",
            designation: employee.designation,
            department: employee.department,
            city: "Noida",
            country: "India",
            isActive: employee.isActive,
            imageURL: employee.imageURL,
            phoneNumbers: []
        )
        
        return EmployeeDetailViewModel(
            employee: domain,
            updateUseCase: updateEmployeeUseCase,
            syncUseCase: syncUseCase
        )
    }
}
