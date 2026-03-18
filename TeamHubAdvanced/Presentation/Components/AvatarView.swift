//
//  AvatarView.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 18/03/26.
//

import SwiftUI

struct AvatarView: View {
    
    let url: URL?
    
    var body: some View {
        Group {
            if let url {
                CachedAsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    placeholder
                }
            } else {
                placeholder
            }
        }
        .frame(width: 44, height: 44)
        .clipShape(Circle())
    }
}

private extension AvatarView {
    
    var placeholder: some View {
        Circle()
            .foregroundStyle(.secondary)
    }
}
