//
//  SLNav.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-26.
//

import SwiftUI

enum Destination: Hashable {
    case user(name: String, imageUrl: String)
}

struct SLNav: View {
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            
            let userViewModel = UserListViewModel(pageNum: Int.random(in: 1...10), pagePer: 50)
            UserListScreen(viewModel: userViewModel){ photo in
                navigationPath.append(Destination.user(name: photo.photographer, imageUrl: photo.src.original))
            }
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .user(let name, let imageUrl):
                    UserScreen(state: UserStateHolder(userName:name, photoUrl:imageUrl)).navigationBarBackButtonHidden(true).toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            // Custom back button
                            SLButton{
                                navigationPath.removeLast()
                            }
                        }
                    }
                }
            }
        }
    }
       
}

#Preview {
    SLNav()
}
