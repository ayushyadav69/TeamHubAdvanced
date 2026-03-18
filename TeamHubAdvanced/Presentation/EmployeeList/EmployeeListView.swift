//
//  EmployeeListView.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 18/03/26.
//

import SwiftUI

struct EmployeeListView: View {
    
    @State private var viewModel: EmployeeListViewModel
    
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
        .onAppear {
            viewModel.onAppear()
        }
        .refreshable {
            viewModel.onRefresh()
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
        ScrollView {
            LazyVStack {
                
                ForEach(viewModel.state.employees) { employee in
                    EmployeeRowView(
                        model: employee,
                        onTap: {
                            viewModel.onEmployeeTap(employee.id)
                        }
                    )
                    .padding(.horizontal)
                    .onAppear {
                        viewModel.onItemAppear(employee.id)
                    }
                }
                
                if viewModel.state.isLoadingNextPage {
                    LoadingView()
                }
            }
        }
    }
}

private extension EmployeeListView {
    
    var shouldShowSearchBar: Bool {
        !viewModel.state.isLoading &&
        viewModel.state.errorMessage == nil &&
        !viewModel.state.isEmpty
    }
}

#Preview("Loading") {
    EmployeeListView(
        viewModel: EmployeeListViewModel(previewState: .loading)
    )
}

#Preview("Loaded") {
    EmployeeListView(
        viewModel: EmployeeListViewModel(previewState: .loaded)
    )
}

#Preview("Empty") {
    EmployeeListView(
        viewModel: EmployeeListViewModel(previewState: .empty)
    )
}

#Preview("Error") {
    EmployeeListView(
        viewModel: EmployeeListViewModel(previewState: .error)
    )
}

#Preview("Pagination") {
    EmployeeListView(
        viewModel: EmployeeListViewModel(previewState: .pagination)
    )
}
