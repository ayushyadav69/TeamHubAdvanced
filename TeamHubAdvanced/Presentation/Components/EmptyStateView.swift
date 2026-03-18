//
//  EmptyStateView.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 18/03/26.
//

import SwiftUI

struct EmptyStateView: View {
    
    let imageName: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 12) {
            
            Image(systemName: imageName)
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            
            Text(title)
                .font(.headline)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    EmptyStateView(
        imageName: "person.3.fill",
        title: "No Employees",
        subtitle: "Try adjusting filters"
    )
}
