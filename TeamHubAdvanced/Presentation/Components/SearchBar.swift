//
//  SearchBar.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 18/03/26.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding(10)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    SearchBar(text: .constant(""), placeholder: "Search employees")
        .padding()
}
