//
//  EmployeeFormUIModel.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 20/03/26.
//

import Foundation
import UIKit

struct EmployeeFormUIModel {
    
    var id: String?
    
    var name: String = ""
    var email: String = ""
    
    var designation: String = ""
    var department: String = ""
    
    var city: String = ""
    var country: String = ""
    
    var isActive: Bool = true
    
    //  IMAGE SUPPORT
    var image: UIImage?          // newly selected
    var imageURL: URL?           // existing (edit case)
    
    var phoneNumbers: [PhoneNumberUIModel] = []
}

struct PhoneNumberUIModel: Identifiable {
    let id = UUID()
    
    var number: String = ""
    var type: PhoneType = .home
}

enum PhoneType: String, CaseIterable {
    case home = "Home"
    case office = "Office"
    case other = "Other"
}
