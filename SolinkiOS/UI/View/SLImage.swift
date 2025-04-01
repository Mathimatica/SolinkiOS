//
//  SLImage.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-04-01.
//

import SwiftUI

struct SLImage: View {
    let imageURLString: String
    let placeholderImageName: String = "placeholder_profile_image"

    var body: some View {
        AsyncImage(url: URL(string: imageURLString)) { phase in
            switch phase {
            case .empty:
                Image(placeholderImageName)
                    .resizable()
                    .scaledToFill()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                Image(placeholderImageName)
                    .resizable()
                    .scaledToFill()
            @unknown default:
                Image(placeholderImageName)
                    .resizable()
                    .scaledToFill()
            }
        }
        .animation(.easeInOut(duration: 0.25), value: imageURLString) // Optional animation
    }
}

#Preview {
    SLImage(imageURLString: "https://via.placeholder.com/150")
}
