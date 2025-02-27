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
        DependencyUtil.shared.setEnvironment(.app)
    }
    
    var body: some Scene {
        WindowGroup {
            SLNav()
        }
    }
}
