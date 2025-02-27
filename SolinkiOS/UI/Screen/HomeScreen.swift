//
//  HomeScreen.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-26.
//

import SwiftUI

struct HomeScreen: View {
    var onNavigateToUser: () -> Void

    var body: some View {
        VStack {
            Button("Navigate to User") {
                onNavigateToUser()
            }
        }
    }
}

#Preview {
    HomeScreen(onNavigateToUser: {
        
    })
}
