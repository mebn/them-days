//
//  ContentView.swift
//  them-days
//
//  Created by Marcus Nilszén on 2025-10-09.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView()
            }
            
            Tab("Settings", systemImage: "gearshape.fill") {
                SettingView()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: CounterItem.self, inMemory: true)
}
