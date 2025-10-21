//
//  themDaysApp.swift
//  them-days
//
//  Created by Marcus Nilszén on 2025-10-09.
//

import SwiftData
import SwiftUI
import WidgetKit

@main
struct them_daysApp: App {
    @Environment(\.scenePhase) private var scenePhase

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
                .onChange(of: scenePhase) { _, newPhase in
                    if newPhase == .active || newPhase == .background {
                        WidgetCenter.shared.reloadTimelines(ofKind: "themDaysWidget")
                    }
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
