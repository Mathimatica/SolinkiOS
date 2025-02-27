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
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            switch viewModel.state {
            case .error(let errorMessage):
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            case .success(let data):
                VStack {
                    Text(data.userName)
                        .font(.largeTitle) // Equivalent to headlineLarge
                        .multilineTextAlignment(.center)
                    Spacer().frame(height: 16)
                    KFImage(URL(string: data.photoUrl))
                        .placeholder {
                            Image("placeholder_profile_image") // Replace with your placeholder image
                                .resizable()
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200) // Equivalent to size(200.dp)
                        .clipShape(Circle()) // Equivalent to CircleShape
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            case .loading:
                ProgressView()
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Equivalent to fillMaxSize
        .padding(16)
    }
}

//#Preview {
//    UserScreen()
//}
