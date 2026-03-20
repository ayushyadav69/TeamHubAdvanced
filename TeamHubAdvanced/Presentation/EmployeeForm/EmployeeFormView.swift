//
//  EmployeeFormView.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 20/03/26.
//

import SwiftUI

struct EmployeeFormView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State var viewModel: EmployeeFormViewModel
    let onSave: (Employee) -> Void
    
    var body: some View {
        
        NavigationStack {   // ✅ REQUIRED
            
            Form {
                
                Section("Profile Image") {
                    if let image = viewModel.form.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    } else if let url = viewModel.form.imageURL {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Circle().fill(Color.gray.opacity(0.3))
                        }
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                    }
                    
                    Button("Select Image") {
                        viewModel.showImagePicker = true
                    }
                    
                    if viewModel.form.image != nil || viewModel.form.imageURL != nil {
                        Button("Remove Image", role: .destructive) {
                            viewModel.removeImage()
                        }
                    }
                }
                
                Section("Basic Info") {
                    TextField("Name", text: $viewModel.form.name)
                    TextField("Email", text: $viewModel.form.email)
                }
                
                Section("Work") {
                    TextField("Designation", text: $viewModel.form.designation)
                    TextField("Department", text: $viewModel.form.department)
                }
                
                Section("Location") {
                    TextField("City", text: $viewModel.form.city)
                    TextField("Country", text: $viewModel.form.country)
                }
                
                Section("Status") {
                    Toggle("Active", isOn: $viewModel.form.isActive)
                }
                
                Section("Phone Numbers") {
                    ForEach($viewModel.form.phoneNumbers) { $phone in
                        VStack {
                            TextField("Number", text: $phone.number)
                            
                            Picker("Type", selection: $phone.type) {
                                ForEach(PhoneType.allCases, id: \.self) {
                                    Text($0.rawValue)
                                }
                            }
                        }
                    }
                    
                    if viewModel.form.phoneNumbers.count < 3 {
                        Button("Add Phone") {
                            viewModel.addPhone()
                        }
                    }
                }
            }
            .navigationTitle(viewModel.form.id == nil ? "Add Employee" : "Edit Employee")
            .toolbar {
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let employee = viewModel.buildEmployee()
                        onSave(employee)
                        dismiss()
                    }
                    .disabled(viewModel.form.name.isEmpty)
                }
            }
        }
    }
}
