//
//  EmployeeUIModel.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 18/03/26.
//

import Foundation

struct EmployeeListItemUIModel: Identifiable {
    let id: String
    let name: String
    let designation: String
    let department: String
    let imageURL: URL?
    let isActive: Bool
}

extension EmployeeListItemUIModel {
    
    static let mock = EmployeeListItemUIModel(
        id: "1",
        name: "Ayush Yadav",
        designation: "iOS Developer",
        department: "Engineering",
        imageURL: nil,
        isActive: true
    )
    
    static let mockList: [EmployeeListItemUIModel] = [
        mock,
        EmployeeListItemUIModel(
            id: "2",
            name: "Rohit Sharma",
            designation: "Manager",
            department: "HR",
            imageURL: nil,
            isActive: false
        )
    ]
}
