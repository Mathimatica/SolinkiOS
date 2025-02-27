//
//  SLNav.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-26.
//

import SwiftUI

enum Destination: Hashable {
    case user(userId: Int, pageNum: Int, pagePer: Int)
}

struct SLNav: View {
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
           NavigationStack(path: $navigationPath) {
               HomeScreen {
                   let randomNumber = Int.random(in: 1...10)
                   navigationPath.append(Destination.user(userId: randomNumber, pageNum: randomNumber, pagePer: randomNumber))
               }
               .navigationDestination(for: Destination.self) { destination in
                   switch destination {
                   case .user(let userId, let pageNum, let pagePer):
                       let userViewModel = UserViewModel(userId: userId, pageNum: pageNum, pagePer: pagePer)
                       UserScreen(viewModel: userViewModel)
                   }
               }
           }
       }
}

#Preview {
    SLNav()
}
