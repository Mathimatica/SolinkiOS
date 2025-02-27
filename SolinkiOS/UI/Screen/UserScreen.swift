//
//  UserScreen.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-26.
//

import SwiftUI
import Kingfisher

struct UserScreen: View {
    @ObservedObject var viewModel: UserViewModel
    var body: some View {
        UserScreenContents(state: viewModel.state)
    }
}

struct UserScreenContents: View {
    var state: StateHolder<UserStateHolder>
    var body: some View {
            VStack {
                switch state {
                case .error(let errorMessage):
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center) // Horizontal centering for text
                case .success(let data):
                    VStack(spacing: 16) { // Explicit spacing instead of Spacer
                        Text(data.userName)
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                        KFImage(URL(string: data.photoUrl))
                            .placeholder {
                                Image("placeholder_profile_image").resizable()
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                    }
                case .loading:
                    ProgressView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // Center the VStack contents
            .padding(16)
        }
}

// Preview provider
#Preview("Success State") {
    UserScreenContents(state: .success(UserStateHolder(userName: "Preview User", photoUrl: "https://picsum.photos/200")))
}

#Preview("Loading State") {
    UserScreenContents(state: .loading)
}

#Preview("Error State") {
    UserScreenContents(state: .error("Something went wrong!"))
}
