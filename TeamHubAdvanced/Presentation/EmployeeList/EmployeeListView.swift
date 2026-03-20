//
//  EmployeeListView.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 18/03/26.
//

import SwiftUI

struct EmployeeListView: View {
    
    @State private var viewModel: EmployeeListViewModel
    @State private var showAddSheet = false
    
    init(viewModel: EmployeeListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            if shouldShowSearchBar {
                SearchBar(
                    text: $viewModel.searchText,
                    placeholder: viewModel.state.searchPlaceholder
                )
                .padding()
            }
            
            content
        }
        .navigationTitle("Employees")
        .onAppear {
            viewModel.onAppear()
        }
        .refreshable {
            viewModel.onRefresh()
        }
        .toolbar {
            Button {
                showAddSheet = true
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showAddSheet) {
            
            EmployeeFormView(
                viewModel: EmployeeFormViewModel(),
                onSave: { newEmployee in
                    viewModel.onEmployeeAdded(newEmployee)
                }
            )
        }
    }
}

private extension EmployeeListView {
    
    @ViewBuilder
    var content: some View {
        
        if viewModel.state.isLoading && viewModel.state.employees.isEmpty {
            
            LoadingView()
            
        } else if let error = viewModel.state.errorMessage,
                  viewModel.state.employees.isEmpty {
            
            ErrorView(
                imageName: viewModel.state.errorImageName,
                message: error,
                buttonTitle: viewModel.state.retryButtonTitle,
                onRetry: viewModel.onAppear
            )
            
        } else if viewModel.state.isEmpty {
            
            EmptyStateView(
                imageName: viewModel.state.emptyImageName,
                title: viewModel.state.emptyTitle,
                subtitle: viewModel.state.emptySubtitle
            )
            
        } else {
            
            listView
        }
    }
    
    var listView: some View {
        
        List {
            
            ForEach(viewModel.state.employees) { employee in
                NavigationLink {
                    EmployeeDetailView(
                        viewModel: viewModel.makeDetailViewModel(employee: employee)
                    )
                } label: {
                    EmployeeRowView(
                        model: employee,
                        onTap: {},
                        onDelete: {}
                    )
                }
                .onAppear {
                    viewModel.onItemAppear(employee.id)
                }
            }
            .onDelete { indexSet in
                guard let index = indexSet.first else { return }
                let id = viewModel.state.employees[index].id
                viewModel.onDeleteEmployee(id)
            }
            
            if viewModel.state.isLoadingNextPage {
                LoadingView()
            }
        }
        .listStyle(.plain)
        
    }
}

private extension EmployeeListView {
    
    var shouldShowSearchBar: Bool {
        !viewModel.state.isLoading &&
        viewModel.state.errorMessage == nil &&
        !viewModel.state.isEmpty
    }
}
