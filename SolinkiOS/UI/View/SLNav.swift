import SwiftUI

enum Destination: Hashable {
    case user(name: String, imageUrl: String)
}

struct SLNav: View {
    @State private var selectedTab = 0

    var body: some View {

        TabView(selection: $selectedTab) {

            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
                .tag(1)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
    }
}

// HomeView with its own NavigationStack
struct HomeView: View {
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            UserListScreen { photo in
                navigationPath.append(
                    Destination.user(
                        name: photo.photographer, imageUrl: photo.src.original))
            }
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .user(let name, let imageUrl):
                    UserScreen(
                        state: UserStateHolder(
                            userName: name, photoUrl: imageUrl)
                    )
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            SLButton {
                                navigationPath.removeLast()
                            }
                        }
                    }
                }
            }
        }
    }
}

// Placeholder views for other tabs
struct FavoritesView: View {
    var body: some View {
        NavigationStack {
            CardsView()
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            Text("Settings Screen")
        }
    }
}

#Preview {
    SLNav()
}
