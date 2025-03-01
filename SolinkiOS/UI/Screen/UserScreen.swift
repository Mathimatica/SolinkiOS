//
//  UserScreen.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-26.
//

import SwiftUI
import Kingfisher

struct UserScreen: View {
    var state: UserStateHolder
    var body: some View {
            VStack {
                Text(state.userName)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                KFImage(URL(string: state.photoUrl))
                    .placeholder {
                        Image("placeholder_profile_image").resizable()
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // Center the VStack contents
            .padding(16)
        }
}

// Preview provider
#Preview("Success State") {
    UserScreen(state: UserStateHolder(userName: "Preview User", photoUrl: "https://picsum.photos/200"))
}
