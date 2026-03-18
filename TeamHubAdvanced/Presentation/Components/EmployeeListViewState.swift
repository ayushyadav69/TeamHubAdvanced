//
//  EmployeeListViewState.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 18/03/26.
//

import Foundation

struct EmployeeListViewState {
    
    let employees: [EmployeeListItemUIModel]
    
    let isLoading: Bool
    let isRefreshing: Bool
    let isLoadingNextPage: Bool
    let isEmpty: Bool
    
    let errorMessage: String?
    
    let emptyImageName: String
    let errorImageName: String
    
    let searchPlaceholder: String
    let emptyTitle: String
    let emptySubtitle: String
    let retryButtonTitle: String
}

extension EmployeeListViewState {
    
    static let loading = EmployeeListViewState(
        employees: [],
        isLoading: true,
        isRefreshing: false,
        isLoadingNextPage: false,
        isEmpty: false,
        errorMessage: nil,
        emptyImageName: "",
        errorImageName: "",
        searchPlaceholder: "Search employees",
        emptyTitle: "",
        emptySubtitle: "",
        retryButtonTitle: "Retry"
    )
    
    static let loaded = EmployeeListViewState(
        employees: EmployeeListItemUIModel.mockList,
        isLoading: false,
        isRefreshing: false,
        isLoadingNextPage: false,
        isEmpty: false,
        errorMessage: nil,
        emptyImageName: "",
        errorImageName: "",
        searchPlaceholder: "Search employees",
        emptyTitle: "",
        emptySubtitle: "",
        retryButtonTitle: "Retry"
    )
    
    static let empty = EmployeeListViewState(
        employees: [],
        isLoading: false,
        isRefreshing: false,
        isLoadingNextPage: false,
        isEmpty: true,
        errorMessage: nil,
        emptyImageName: "tray",
        errorImageName: "",
        searchPlaceholder: "Search employees",
        emptyTitle: "No Employees Found",
        emptySubtitle: "Try adjusting filters",
        retryButtonTitle: "Retry"
    )
    
    static let error = EmployeeListViewState(
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
    
    static let pagination = EmployeeListViewState(
        employees: EmployeeListItemUIModel.mockList,
        isLoading: false,
        isRefreshing: false,
        isLoadingNextPage: true,
        isEmpty: false,
        errorMessage: nil,
        emptyImageName: "",
        errorImageName: "",
        searchPlaceholder: "Search employees",
        emptyTitle: "",
        emptySubtitle: "",
        retryButtonTitle: "Retry"
    )
}
