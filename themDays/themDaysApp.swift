//
//  themDaysApp.swift
//  them-days
//
//  Created by Marcus Nilszén on 2025-10-09.
//

import SwiftData
import SwiftUI

@main
struct them_daysApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CounterItem.self,
        ])

        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            groupContainer: .identifier("group.com.anon.themDays")
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
