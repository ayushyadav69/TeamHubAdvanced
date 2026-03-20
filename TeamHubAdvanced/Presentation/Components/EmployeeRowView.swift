//
//  EmployeeRowView.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 18/03/26.
//

import SwiftUI

struct EmployeeRowView: View {
    
    let model: EmployeeListItemUIModel
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                AvatarView(url: model.imageURL)
                infoSection
                
                Spacer()
                
                StatusBadge(isActive: model.isActive)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

private extension EmployeeRowView {
    
    var infoSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(model.name)
                .font(.headline)
            
            Text("\(model.designation) • \(model.department)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
}

#Preview {
    EmployeeRowView(
        model: .mock,
        onTap: {}, onDelete: {}
    )
    .padding()
}
