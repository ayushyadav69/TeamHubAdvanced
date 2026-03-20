//
//  EmployeeDetailView.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 20/03/26.
//

import SwiftUI

struct EmployeeDetailView: View {
    
    @State var viewModel: EmployeeDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                AvatarView(url: viewModel.employee.imageURL)
                
                Text(viewModel.employee.name)
                    .font(.title2)
                    .bold()
                
                Text(viewModel.employee.email)
                    .foregroundStyle(.secondary)
                
                Text("\(viewModel.employee.designation) • \(viewModel.employee.department)")
                
                Text("\(viewModel.employee.city), \(viewModel.employee.country)")
                
                StatusBadge(isActive: viewModel.employee.isActive)
                
                phoneSection
            }
            .padding()
        }
        .navigationTitle("Employee")
        .toolbar {
            Button("Edit") {
                viewModel.onEditTapped()
            }
        }
        .sheet(isPresented: $viewModel.showEdit) {
            
            EmployeeFormView(
                viewModel: EmployeeFormViewModel(
                    form: mapToForm(viewModel.employee)
                ),
                onSave: { updated in
                    viewModel.onEmployeeUpdated(updated)
                }
            )
        }
    }
}

private extension EmployeeDetailView {
    
    @ViewBuilder
    var phoneSection: some View {
        
        if viewModel.employee.phoneNumbers.isEmpty {
            
            Text("No phone numbers")
                .foregroundStyle(.secondary)
            
        } else {
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text("Phone Numbers")
                    .font(.headline)
                
                ForEach(viewModel.employee.phoneNumbers, id: \.number) { phone in
                    
                    HStack {
                        Text(phone.type.capitalized)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text(phone.number)
                    }
                }
            }
        }
    }
    
    private func mapToForm(_ employee: Employee) -> EmployeeFormUIModel {
        
        EmployeeFormUIModel(
            id: employee.id,
            name: employee.name,
            email: employee.email,
            designation: employee.designation,
            department: employee.department,
            city: employee.city,
            country: employee.country,
            isActive: employee.isActive,
            image: nil,
            imageURL: employee.imageURL,
            phoneNumbers: employee.phoneNumbers.map {
                PhoneNumberUIModel(
                    number: $0.number,
                    type: PhoneType(rawValue: $0.type) ?? .home
                )
            }
        )
    }
}
