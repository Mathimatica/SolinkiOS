//
//  SolinkiOSApp.swift
//  SolinkiOS
//
//  Created by Josh Phillips on 2025-02-26.
//

import SwiftUI

@main
struct SolinkiOSApp: App {

    init() {

        let appearance = UITabBarAppearance()
        UITabBar.appearance().scrollEdgeAppearance = appearance

        DependencyUtil.shared.setEnvironment(.app)
    }

    var body: some Scene {
        WindowGroup {
            SLNav()
        }
    }
}
