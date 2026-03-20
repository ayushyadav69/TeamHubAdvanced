//
//  EmployeeFormViewModel.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 20/03/26.
//

import Foundation
import Observation
import UIKit

@Observable
final class EmployeeFormViewModel {
    
    var form: EmployeeFormUIModel
    var showImagePicker = false
    
    init(form: EmployeeFormUIModel = EmployeeFormUIModel()) {
        self.form = form
    }
    
    func addPhone() {
        guard form.phoneNumbers.count < 3 else { return }
        form.phoneNumbers.append(PhoneNumberUIModel())
    }
    
    func removePhone(id: UUID) {
        form.phoneNumbers.removeAll { $0.id == id }
    }
    
    func setImage(_ image: UIImage) {
        form.image = image
    }
    
    func removeImage() {
        form.image = nil
        form.imageURL = nil
    }
    
    func buildEmployee() -> Employee {
        mapToDomain()
    }
}

private extension EmployeeFormViewModel {
    
    private func mapToDomain() -> Employee {
        
        let imageURL: URL?
        
        if let image = form.image {
            //  For now → simulate local URL (later upload)
            imageURL = saveImageLocally(image)
        } else {
            imageURL = form.imageURL
        }
        
        return Employee(
            id: form.id ?? UUID().uuidString,
            name: form.name,
            email: form.email,
            designation: form.designation,
            department: form.department,
            city: form.city,
            country: form.country,
            isActive: form.isActive,
            imageURL: imageURL,
            phoneNumbers: form.phoneNumbers.map {
                PhoneNumber(
                    number: $0.number,
                    type: $0.type.rawValue
                )
            }
        )
    }
    
    private func saveImageLocally(_ image: UIImage) -> URL? {
        
        let filename = UUID().uuidString + ".jpg"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        
        try? data.write(to: url)
        
        return url
    }
}
