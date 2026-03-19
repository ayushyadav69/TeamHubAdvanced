//
//  EmployeeMapper.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 19/03/26.
//

import Foundation

struct EmployeeMapper {
    
    // MARK: - Entity → Domain
    
    static func toDomain(_ entity: EmployeeEntity) -> Employee {
        Employee(
            id: entity.id,
            name: entity.name,
            designation: entity.designation,
            department: entity.department,
            isActive: entity.isActive,
            imageURL: entity.imageURL.flatMap { URL(string: $0) }
        )
    }
    
    // MARK: - Domain → Entity (from API)
    
    static func toEntity(
        from employee: Employee,
        createdAt: Date?,
        updatedAt: Date?,
        deletedAt: Date?
    ) -> EmployeeEntity {
        
        EmployeeEntity(
            id: employee.id,
            name: employee.name,
            designation: employee.designation,
            department: employee.department,
            isActive: employee.isActive,
            imageURL: employee.imageURL?.absoluteString,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            syncState: .synced
        )
    }
}
