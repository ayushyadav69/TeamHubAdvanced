//
//  ErrorView.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 18/03/26.
//

import SwiftUI

struct ErrorView: View {
    
    let imageName: String
    let message: String
    let buttonTitle: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            
            Image(systemName: imageName)
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            
            Text(message)
                .font(.headline)
            
            Button(buttonTitle, action: onRetry)
        }
        .padding()
    }
}

#Preview {
    ErrorView(
        imageName: "wifi.slash",
        message: "Something went wrong",
        buttonTitle: "Retry",
        onRetry: {}
    )
}
