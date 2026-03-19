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
    private let syncUseCase: SyncEmployeesUseCase
    
    // MARK: - State
    
    var state: EmployeeListViewState
    var searchText: String = ""
    
    private var currentPage = 1
    private var hasMore = true
    private var isLoading = false
    
    // MARK: - Init
    
    init(fetchEmployeesUseCase: FetchEmployeesUseCase, syncUseCase: SyncEmployeesUseCase) {
        self.fetchEmployeesUseCase = fetchEmployeesUseCase
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
}

//extension EmployeeListViewModel {
//    
//    convenience init(previewState: EmployeeListViewState) {
//        self.init(fetchEmployeesUseCase: DummyUseCase())
//        self.state = previewState
//    }
//}
