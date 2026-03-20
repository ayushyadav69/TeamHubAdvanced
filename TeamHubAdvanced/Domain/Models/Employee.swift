//
//  Employee.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 18/03/26.
//

import Foundation

struct Employee {
    
    let id: String
    
    let name: String
    let email: String
    
    let designation: String
    let department: String
    
    let city: String
    let country: String
    
    let isActive: Bool
    
    let imageURL: URL?
    
    let phoneNumbers: [PhoneNumber]
}

struct PhoneNumber: Codable{
    let number: String
    let type: String   // "home", "office", "other"
}
