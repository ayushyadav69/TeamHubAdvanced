//
//  StatusBadge.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 18/03/26.
//

import SwiftUI

struct StatusBadge: View {
    
    let isActive: Bool
    
    var body: some View {
        Text(isActive ? "Active" : "Inactive")
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .foregroundStyle(textColor)
            .clipShape(Capsule())
    }
}

private extension StatusBadge {
    
    var backgroundColor: Color {
        isActive ? Color.green.opacity(0.2) : Color.red.opacity(0.2)
    }
    
    var textColor: Color {
        isActive ? .green : .red
    }
}
