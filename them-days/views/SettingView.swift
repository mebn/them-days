//
//  SettingView.swift
//  them-days
//
//  Created by Marcus Nilszén on 2025-10-09.
//

import SwiftUI
import SwiftData

struct SettingView: View {
    
    var body: some View {
        NavigationStack {
            Text("hello from setting")
            .navigationTitle("Setting")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: CounterItem.self, inMemory: true)
}
