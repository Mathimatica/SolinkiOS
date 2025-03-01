//
//  HomeScreen.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-26.
//

import SwiftUI
import Kingfisher

struct UserListScreen: View {
    @ObservedObject var viewModel: UserListViewModel
    let onClick: ((Photo) -> Void)
    var body: some View {
        UserListScreenContents(state: viewModel.state, onClick: onClick)
    }
}

struct UserListScreenContents: View {
    var state: StateHolder<UserListStateHolder>
    let onClick: ((Photo) -> Void)
    var body: some View {
            VStack {
                switch state {
                case .error(let errorMessage):
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center) // Horizontal centering for text
                case .success(let data):
                    List(data.users) { userState in
                        UserListItemView(stateHolder: userState, onClick:onClick)
                    }
                    .listStyle(.plain)
                    .background(Color.clear)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top)
                case .loading:
                    ProgressView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
}

struct UserListItemView: View {
    let stateHolder: UserListItemStateHolder
    let onClick: ((Photo) -> Void)
    
    var body: some View {
        HStack {
            Text(stateHolder.name)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            KFImage(URL(string: stateHolder.imageURL))
                .cacheMemoryOnly(false) // Matches ENABLED network cache
                .cacheOriginalImage(false) // Matches DISABLED disk cache
                .fade(duration: 0.25) // Matches crossfade(true)
                .placeholder {
                    Image("placeholder_profile_image")
                        .resizable()
                        .scaledToFill()
                }
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(Circle())
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color(red: 2/255, green: 136/255, blue: 209/255)) // #0288D1
        .cornerRadius(8)
        .shadow(radius: 2)
        .padding(.vertical, 4)
        .onTapGesture {
            stateHolder.processOnClick(onClick)
        }
    }
}

#Preview("Loading State") {
    UserListScreenContents(state: .loading, onClick: {_ in
        
    })
}

#Preview("Success State") {
    
    let stateHolder:StateHolder<UserListStateHolder> = .success(UserListStateHolder(users: [
        createTestUser(name:"Josh"),
        createTestUser(name:"Matt"),
        createTestUser(name:"Nathan"),
        createTestUser(name:"Tiffany"),
        createTestUser(name:"Jason"),
        createTestUser(name:"Bob"),
        createTestUser(name:"Lisa"),
        createTestUser(name:"Henry"),
        createTestUser(name:"John"),
        createTestUser(name:"Kate"),
        createTestUser(name:"Josh"),
        createTestUser(name:"Matt"),
        createTestUser(name:"Nathan"),
        createTestUser(name:"Tiffany"),
        createTestUser(name:"Jason"),
        createTestUser(name:"Bob"),
        createTestUser(name:"Lisa"),
        createTestUser(name:"Henry"),
        createTestUser(name:"John"),
        createTestUser(name:"Kate"),
        createTestUser(name:"Josh"),
        createTestUser(name:"Matt"),
        createTestUser(name:"Nathan"),
        createTestUser(name:"Tiffany"),
        createTestUser(name:"Jason"),
        createTestUser(name:"Bob"),
        createTestUser(name:"Lisa"),
        createTestUser(name:"Henry"),
        createTestUser(name:"John"),
        createTestUser(name:"Kate"),
        createTestUser(name:"Josh"),
        createTestUser(name:"Matt"),
        createTestUser(name:"Nathan"),
        createTestUser(name:"Tiffany"),
        createTestUser(name:"Jason"),
        createTestUser(name:"Bob"),
        createTestUser(name:"Lisa"),
        createTestUser(name:"Henry"),
        createTestUser(name:"John"),
        createTestUser(name:"Kate")]))
    
                                                                
    UserListScreenContents(state: stateHolder, onClick: {_ in 
        
    })
}

#Preview("Failure State") {
    UserListScreenContents(state: .error("Unknown Error"), onClick: {_ in
        
    })
}

func createTestUser(name:String) -> UserListItemStateHolder{
    return UserListItemStateHolder(
        id: UUID(), name: name,
            imageURL: "",
        processOnClick: { callback in
           
        }
        )
}
