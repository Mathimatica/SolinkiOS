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
        .animation(.easeInOut(duration: 0.25), value: imageURLString)  // Optional animation
    }
}

#Preview {
    GeometryReader { geometry in
        VStack(alignment: .center) {
            SLImage(
                imageURLString:
                    "https://images.pexels.com/photos/104827/cat-pet-animal-domestic-104827.jpeg?cs=srgb&dl=pexels-pixabay-104827.jpg&fm=jpg"
            )
            .frame(width: geometry.size.width, height: geometry.size.width)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.black, lineWidth: 5))
        }
        .frame(width: geometry.size.width, height: geometry.size.height)  // make it fill the
    }
}
