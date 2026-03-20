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
        
        let data = entity.phoneNumbersData.data(using: .utf8)
        let phones = (try? JSONDecoder().decode([PhoneNumber].self, from: data ?? Data())) ?? []
        
        return Employee(
            id: entity.id,
            name: entity.name,
            email: entity.email,
            designation: entity.designation,
            department: entity.department,
            city: entity.city,
            country: entity.country,
            isActive: entity.isActive,
            imageURL: entity.imageURL.flatMap { URL(string: $0) },
            phoneNumbers: phones
        )
    }
    
    // MARK: - Domain → Entity (from API)
    
    static func toEntity(
        from employee: Employee,
        createdAt: Date?,
        updatedAt: Date?,
        deletedAt: Date?
    ) -> EmployeeEntity {
        
        let phoneData = try? JSONEncoder().encode(employee.phoneNumbers)
        let phoneString = phoneData.flatMap { String(data: $0, encoding: .utf8) } ?? "[]"
        
        return EmployeeEntity(
            id: employee.id,
            name: employee.name,
            designation: employee.designation,
            department: employee.department,
            isActive: employee.isActive,
            email: employee.email,
            city: employee.city,
            country: employee.country,
            imageURL: employee.imageURL?.absoluteString,
            phoneNumbersData: phoneString,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            syncState: .synced
        )
    }}
