//
//  TeamHubAdvancedApp.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 18/03/26.
//

import SwiftUI
import SwiftData

@main
struct TeamHubApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([EmployeeEntity.self])
        let container = try! ModelContainer(for: schema)
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(sharedModelContainer)
    }
}
